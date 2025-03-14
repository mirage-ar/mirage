//
//  ApolloRepository.swift
//  Mirage
//
//  Created by Saad on 01/03/2023.
//

import Apollo
import ApolloAPI
import ApolloSQLite
import ApolloWebSocket
import Combine
import Foundation


public class ApolloRepository {
    private weak var appRestoredFromBackgroundPhaseObserver: NSObjectProtocol?
    private weak var appEnteredBackgroundPhaseObserver: NSObjectProtocol?

    private var subscriptions = [SubscriptionName: Apollo.Cancellable]()
    var userPropertiesStorage: UserPropertiesStorage = UserDefaultsStorage()
    var userProfileStorage: UserProfileStorage = UserDefaultsStorage()

    /// Apollo Subscription when a new Mira is Added
    var miraAddSubscription: AnyPublisher<Mira, Error>?

    /// For check internet connection
    private let reachabilityProvider: ReachabilityProvider

    /// A common store to use for `normalTransport` and `client`.
    private lazy var store = ApolloStore(cache: InMemoryNormalizedCache())

    /// A web socket transport to use for subscriptions
    private lazy var webSocketTransport: WebSocketTransport = getWebSocketTransport()

    /// An HTTP transport to use for queries and mutations
    private lazy var normalTransport: RequestChainNetworkTransport = {
        return transportLayerWithUrl(apiEndPoint)
    }()
    
    /// An HTTP transport to use for queries and mutations for appsync conforming to subscriptions
    private lazy var normalTransportAppsync: RequestChainNetworkTransport = {
        return transportLayerWithUrl(apiEndPointAppSync)
    }()
    
    /// A client to use for queries and mutations
    private lazy var client: ApolloClient = getSQLClient(transport: normalTransport)

    /// A client to use for queries and mutations for appsync conforming to subscriptions
    private lazy var clientAppSync: ApolloClient = getSQLClient(transport: normalTransportAppsync)

    private let apiEndPoint: String
    private let apiEndPointAppSync: String
    private let host: String
    private let webSocketEndpoint: String

    let tokenService: UserTokenService

    private var userAuthenticatedSubject = PassthroughSubject<Bool, Never>()
    /// An event of whether a user was automatically logged out
    public lazy var userAuthenticated = userAuthenticatedSubject.eraseToAnyPublisher()

    public init(apiEndPoint: String,
                apiEndPointAppSync: String,
                webSocketEndpoint: String,
                host: String,
                reachabilityProvider: ReachabilityProvider)
    {
        self.apiEndPoint = apiEndPoint
        self.apiEndPointAppSync = apiEndPointAppSync
        self.host = host
        self.webSocketEndpoint = webSocketEndpoint
        self.reachabilityProvider = reachabilityProvider
        self.tokenService = DefaultUserTokenService()

        addAppPhaseNotifications()
    }

    deinit {
        cancelAllSubscriptions()
        removeAppPhaseNotifications()
    }

    // MARK: Web socket manipulation

    /// Sets a new web socket connection and updates the client with it
    private func updateWebSocket() {
        webSocketTransport = getWebSocketTransport()
        client = getClient(transport: normalTransport)
        clientAppSync = getClient(transport: normalTransportAppsync)
    }

    // MARK: App foreground/background handling

    /// Adds app foreground and background observers to the NotificationCenter
    private func addAppPhaseNotifications() {
        appRestoredFromBackgroundPhaseObserver = NotificationCenter.default.addObserver(forName: .appRestoredFromBackground,
                                                                                        object: nil,
                                                                                        queue: nil) { [weak self] _ in
            self?.handleAppRestoredFromBackgroundPhase()
        }

        appEnteredBackgroundPhaseObserver = NotificationCenter.default.addObserver(forName: .appEnteredBackground,
                                                                                   object: nil,
                                                                                   queue: nil) { [weak self] _ in
            self?.handleAppEnteredBackgroundPhase()
        }
    }

    /// Sets a new web socket connection and posts an event that subscriptions need to be restored
    private func handleAppRestoredFromBackgroundPhase() {
        updateWebSocket()

        NotificationCenter.default.post(name: .restoreSubscriptions, object: nil)
    }

    /// Cancels all subscriptions if they exist
    private func handleAppEnteredBackgroundPhase() {
        cancelAllSubscriptions()
    }

    /// Removes app foreground and background observers from the NotificationCenter if they exist
    private func removeAppPhaseNotifications() {
        if let appRestoredFromBackgroundPhaseObserver = appRestoredFromBackgroundPhaseObserver {
            NotificationCenter.default.removeObserver(appRestoredFromBackgroundPhaseObserver)
        }

        if let appRestoredFromBackgroundPhaseObserver = appRestoredFromBackgroundPhaseObserver {
            NotificationCenter.default.removeObserver(appRestoredFromBackgroundPhaseObserver)
        }
    }
    
    private func transportLayerWithUrl(_ url: String) -> RequestChainNetworkTransport {
        let sessionConfiguration = URLSessionConfiguration.default

        let client = URLSessionClient(sessionConfiguration: sessionConfiguration, callbackQueue: nil)
        let provider = NetworkInterceptorProvider(store: getSQLStore(),
                                                  client: client,
                                                  userTokenService: tokenService)
        let url = URL(string: url)!

        return RequestChainNetworkTransport(interceptorProvider: provider,
                                            endpointURL: url)

    }

    // MARK: Token setup

    /// Handles the user token update. Saves the token to or removes it from a secure storage.
    /// Updates the web socket transport header adding or removing the token
    ///
    ///  - parameters: An optional user token. If the token is nil removes it, othewise adds it
    ///
    func handleTokenUpdate(_ token: String?) {
        if let token = token {
            tokenService.saveAccessToken(token)
        } else {
            tokenService.removeAccessToken()
        }

        updateWebSocket()
    }

    /// Creates a web socket transport to work with subsctiptions
    ///
    ///  - returns: A web socket transport object
    ///
    private func getWebSocketTransport() -> WebSocketTransport {
        let authToken = tokenService.getAuthorizationHeader()?.value ?? ""
        let authKey = tokenService.getAuthorizationHeader()?.key ?? "Authorization"
        let authDict: [String: any JSONEncodable] = [
            authKey: authToken,
            "host": host,
        ]

        let headerData: Data = try! JSONSerialization.data(withJSONObject: authDict, options: JSONSerialization.WritingOptions.prettyPrinted)
        let headerBase64 = headerData.base64EncodedString()

        let payloadData = try! JSONSerialization.data(withJSONObject: [:], options: JSONSerialization.WritingOptions.prettyPrinted)
        let payloadBase64 = payloadData.base64EncodedString()

        let url = URL(string: webSocketEndpoint + "?header=\(headerBase64)&payload=\(payloadBase64)")!
        let request = URLRequest(url: url)

        let webSocketClient = WebSocket(request: request, protocol: .graphql_ws)

        guard let authorizationHeader = tokenService.getAuthorizationHeader() else {
            let configuration = WebSocketTransport.Configuration(reconnect: true, reconnectionInterval: .subscriptionReconnectionInterval)
            return WebSocketTransport(websocket: webSocketClient,
                                      store: store)
        }
        

       
        
        let requestBodyCreator = AppSyncRequestBodyCreator([authKey: authToken], host: host)

        let configuration = WebSocketTransport.Configuration(reconnect: true, reconnectionInterval: .subscriptionReconnectionInterval, requestBodyCreator: requestBodyCreator)
        
        let transport = WebSocketTransport(websocket: webSocketClient,
                                  config: configuration)
        transport.delegate = self
        return transport
    }
    /// A endpoint request url that web socket conneting.
    ///
    /// header-parameter-format-based-on-appsync-api-authorization-mode
    ///https://docs.aws.amazon.com/appsync/latest/devguide/real-time-websocket-client.html#header-parameter-format-based-on-appsync-api-authorization-mode)


    /// Creates an Apollo client with http and web socket transports
    ///
    ///  - returns: An Apollo client
    ///
    private func getClient(transport: RequestChainNetworkTransport) -> ApolloClient {
        // A split network transport to allow the use of both of the above
        // transports through a single `NetworkTransport` instance.

        // This code is commited to be used when subscriptions are there
         let splitNetworkTransport = SplitNetworkTransport(uploadingNetworkTransport: transport,
                                                        webSocketNetworkTransport: webSocketTransport)

        return ApolloClient(networkTransport: splitNetworkTransport,
                            store: store)
    }

    private func getSQLClient(transport: RequestChainNetworkTransport) -> ApolloClient {
        // A split network transport to allow the use of both of the above
        // transports through a single `NetworkTransport` instance.

        // This code is commited to be used when subscriptions are there
         let splitNetworkTransport = SplitNetworkTransport(uploadingNetworkTransport: transport,
                                                        webSocketNetworkTransport: webSocketTransport)

        do {
            let documentsPath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileUrl = documentsPath.appendingPathComponent("apollo_cache.sqlite")
            let sqliteCache = try SQLiteNormalizedCache(fileURL: fileUrl)

            return ApolloClient(networkTransport: splitNetworkTransport,
                                store: getSQLStore())
        } catch {
            print("Error creating ApolloSQLite Client: \(error)")
            return getClient(transport: transport)
        }
    }

    private func getSQLStore() -> ApolloStore {
        do {
            let documentsPath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileUrl = documentsPath.appendingPathComponent("apollo_cache.sqlite")
            let sqliteCache = try SQLiteNormalizedCache(fileURL: fileUrl)

            return ApolloStore(cache: sqliteCache)
        } catch {
            print("Error creating ApolloSQLite Client: \(error)")
            return store
        }
    }

    // MARK: Data manipulations

    /// Performs the query fetch from the server
    ///
    ///  - parameters:
    ///     - query: The query to fetch
    ///     - callbackQueue: The dispatch queue to receive data on
    ///
    ///  - returns: A publisher of the query data or error
    ///
    func fetch<Query: GraphQLQuery>(query: Query,
                                    cachePolicy: CachePolicy = .fetchIgnoringCacheData,
                                    callbackQueue: DispatchQueue = .global(qos: .userInitiated))
        -> AnyPublisher<Query.Data, Error>
    {
        Future<Query.Data, Error> { [weak self] promise in

            guard let self else {
                return
            }

            self.client.fetch(query: query, cachePolicy: cachePolicy, queue: callbackQueue) { response in
                let result = self.handleGraphQLResponse(response)
//                print("Response: \(response)")
                print("result: \(result)")
                promise(result)
            }

        }.eraseToAnyPublisher()
    }

    /// Performs the mutation on the server
    ///
    ///  - parameters:
    ///     - mutation: The mutation to perform
    ///     - callbackQueue: The dispatch queue to receive data on
    ///
    ///  - returns: A publisher of the mutation data or error
    ///
    func perform<Mutation: GraphQLMutation>(mutation: Mutation,
                                            cachePolicy: CachePolicy = .returnCacheDataAndFetch,
                                            callbackQueue: DispatchQueue = .global(qos: .userInitiated))
        -> AnyPublisher<Mutation.Data, Error>
    {
        Future<Mutation.Data, Error> { [weak self] promise in

            guard let self else {
                return
            }

            self.client.perform(mutation: mutation, queue: callbackQueue) { response in
                let result = self.handleGraphQLResponse(response)
//                print("response: \(response)")
                print("result: \(result)")
                promise(result)
            }

        }.eraseToAnyPublisher()
    }

    /// Performs the mutation on the server
    ///
    ///  - parameters:
    ///     - mutation: The mutation to perform
    ///     - callbackQueue: The dispatch queue to receive data on
    ///
    ///  - returns: A publisher of the mutation data or error
    ///
    func performAppsync<Mutation: GraphQLMutation>(mutation: Mutation,
                                            cachePolicy: CachePolicy = .returnCacheDataAndFetch,
                                            callbackQueue: DispatchQueue = .global(qos: .userInitiated))
        -> AnyPublisher<Mutation.Data, Error>
    {
        Future<Mutation.Data, Error> { [weak self] promise in

            guard let self else {
                return
            }

            self.clientAppSync.perform(mutation: mutation, queue: callbackQueue) { response in
                let result = self.handleGraphQLResponse(response)
//                print("response: \(response)")
                print("result: \(result)")
                promise(result)
            }

        }.eraseToAnyPublisher()
    }
    // MARK: Subscriptions

    /// Subscribes to the server event
    ///
    ///  - parameters:
    ///     - subscription: The subscription to listen to
    ///     - subscriptionName: A subscription to store the subscription by
    ///     - callbackQueue: The dispatch queue to receive data on
    ///
    ///  - returns: A publisher of the subscription data or error
    ///
    func subscribe<Subscription: GraphQLSubscription>(to subscription: Subscription,
                                                      subscriptionName: SubscriptionName,
                                                      callbackQueue: DispatchQueue = .global(qos: .userInitiated))
        -> AnyPublisher<Subscription.Data, Error>
    {
        let subject = PassthroughSubject<Subscription.Data, Error>()

        let cancellable = clientAppSync.subscribe(subscription: subscription,
                                           queue: callbackQueue) { [weak self] response in
            guard let result = self?.handleGraphQLResponse(response) else { return }

            subject.send(result: result)
        }

        subscriptions[subscriptionName] = cancellable

        return subject.eraseToAnyPublisher()
    }

    /// Cancels the server event subscription
    ///
    ///  - parameters:
    ///     - name: A name of the subscription to cancel
    ///
    func cancelSubscription(name: SubscriptionName) {
        subscriptions.removeValue(forKey: name)?.cancel()
    }

    /// Cancels all server event subscriptions
    func cancelAllSubscriptions() {
        subscriptions.forEach { self.cancelSubscription(name: $0.key) }
        webSocketTransport.closeConnection()

        miraAddSubscription = nil
    }

    enum SubscriptionName {
        // Subscriptions name goes here. e.g.
        case miraAdded
    }

    // MARK: Authentication status check

    /// Updates the user token and sends authentication event after successful log in
    ///
    ///  - parameters:
    ///     - token: New access token
    ///
    func handleUserAuthentication(_ token: String) {
        handleTokenUpdate(token)

        userAuthenticatedSubject.send(true)
    }

    /// Checks whether an error code is of an authentication error or a server error
    ///
    ///  - parameters:
    ///     - statusCode: An error status code to be checked
    ///
    ///  - returns: A network repository of the corresponding type if it's an authentication error or a server error. Otherwise, returns nil
    ///
    private func getStatusCodeError(for statusCode: Int) -> NetworkError? {
        if statusCode == NetworkError.unauthenticatedErrorCode {
            userAuthenticatedSubject.send(false)

            return .unauthenticated
        }

        if NetworkError.clientErrorsCodes ~= statusCode {
            return .serverError
        }

        return nil
    }

    // MARK: GraphQL response manipulations

    /// Extracts a result from a GraphQL response
    ///
    ///  - parameters:
    ///     - response: A GraphQL response to be handled
    ///
    ///  - returns: A GraphQL response result
    ///
    private func handleGraphQLResponse<T>(_ response: Result<GraphQLResult<T>, Error>) -> Result<T, Error> {
        switch response {
        case .success(let graphQLResult):
            if let graphQLError = graphQLResult.errors?.first {
                let error = handleGraphQLError(graphQLError)

                return .failure(error)
            }

            guard let data = graphQLResult.data else {
                return .failure(NetworkError.dataMissing)
            }

            return .success(data)

        case .failure(let error):
            let error = handleError(error)

            return .failure(error)
        }
    }

    /// Checks an error status code and parses the error message
    ///
    ///  - parameters:
    ///     - error: A GraphQL error to be checked
    ///
    ///  - returns: A new error type with the parsed message on success or the passed error on fail
    ///
    private func handleGraphQLError(_ error: GraphQLError) -> Error {
        if let statusCode = error[.statusCodeResponseKey] as? Int,
           let statusCodeError = getStatusCodeError(for: statusCode)
        {
            return statusCodeError
        }

        guard let errorMessage = error.getErrorMessage() else {
            return error
        }

        return NetworkError.requestError(message: errorMessage)
    }

    /// Checks an error status code and casts to the corresponding error
    ///
    ///  - parameters:
    ///     - error: An error to be checked
    ///
    ///  - returns: A new error type or the passed error on fail
    ///
    private func handleError(_ error: Error) -> Error {
        if case ResponseCodeInterceptor.ResponseCodeError.invalidResponseCode(let response, let data) = error {
            if let statusCode = response?.statusCode,
               let statusCodeError = getStatusCodeError(for: statusCode)
            {
                return statusCodeError
            }

            if let dictionary = data?.toDictionary(),
               let errorMessage = dictionary.firstDictionary(key: .errorResponseKey)?.getErrorMessage()
            {
                return NetworkError.requestError(message: errorMessage)
            }
        }

        return reachabilityProvider.checkIfNetworkFailed(handled: error)
    }
}

extension ApolloRepository: UserTokenNetworkRepository {
    /// Updates user authentication token
    ///
    /// - parameters:
    ///     - token: A new user authentication token
    ///
    public func updateUserToken(_ token: String) {
        handleTokenUpdate(token)
    }
}

private extension Double {
    static var subscriptionReconnectionInterval: Double = 1
}

private extension String {
    static var statusCodeResponseKey = "statusCode"
    static var errorResponseKey = "errors"
    static var errorFieldsResponseKey = "fields"
    static var errorMessageResponseKey = "message"
}

private extension NetworkError {
    static var unauthenticatedErrorCode = 401
    static var clientErrorsCodes = 402 ... 499
}

private protocol ErrorSubscript {
    subscript(key: String) -> Any? { get }
}

extension GraphQLError: ErrorSubscript {}

extension Dictionary: ErrorSubscript where Key == String, Value == Any {}

private extension ErrorSubscript {
    func firstDictionary(key: String) -> [String: Any]? {
        (self[key] as? [[String: Any]])?.first
    }

    func getErrorMessage() -> String? {
        (firstDictionary(key: .errorFieldsResponseKey)?.first?.value as? [String])?.first ??
            (self[.errorMessageResponseKey] as? String)
    }
}

public extension Notification.Name {
    /// An event that subscriptions need to be restored
    static var restoreSubscriptions = Notification.Name("restoreSubscriptions")
}

