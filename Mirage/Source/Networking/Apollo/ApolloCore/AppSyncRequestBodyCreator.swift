//
//  AppSyncRequestBodyCreator.swift
//  Mirage
//
//  Created by Saad on 29/09/2023.
//

import Foundation
import Apollo

enum PayloadKey: String {
    case data
    case query
    case variables
    case extensions
    case authorization
}
public typealias GraphQLMap = [String: JSONEncodable?]


class AppSyncRequestBodyCreator: RequestBodyCreator {
    init(_ authorization: [String: String], host: String) {
        self.authorization = authorization
        self.host = host
    }
    let host: String

    private var authorization: [String: String]

    public func requestBody<Operation: GraphQLOperation>(
      for operation: Operation,
      sendQueryDocument: Bool,
      autoPersistQuery: Bool
    ) -> JSONEncodableDictionary {
        var body: JSONEncodableDictionary = [:]
        
        let operationIdentifier = Operation.operationIdentifier ?? "key-cf23-4cb8-9fcb-152ae4fd1e69"
        let tokenService = DefaultUserTokenService()
        var dataInfo: [String: Any] = [:]
        dataInfo[PayloadKey.variables.rawValue] = operation.__variables ?? [:]
        dataInfo[PayloadKey.query.rawValue] = Operation.definition?.queryDocument ?? "subscription OnMiraAdd { miraAdded { __typename id miraMedia { __typename contentType assetUrl shape position { __typename id transform } modifier { __typename id type amount } } creator { __typename id phone username profileImage profileDescription } location { __typename  latitude longitude elevation heading } viewed isFriend collectors { __typename id phone username profileImage profileDescription } } }"//Operation.definition?.queryDocument ?? "subscription OnMiraAdd { miraAdded { __typename id miraMedia { __typename id contentType assetUrl shape position { __typename id transform } modifier { __typename id type amount } } creator { __typename id phone username profileImage profileDescription } location { __typename id latitude longitude elevation heading } viewed isFriend collectors { __typename id phone username profileImage profileDescription } } }" //default value is for onMiraAdd subscription onMiraAdd {\n miraAdded {\n __typename \n id \n } }

        // The data portion of the body needs to have the query and variables as well.
        do {
            
            
            let data = try JSONSerialization.data(withJSONObject: dataInfo, options: .prettyPrinted)
            let jsonString = String(data: data, encoding: .utf8)
            body[PayloadKey.data.rawValue] = jsonString
            let authToken = tokenService.getAuthorizationHeader()?.value ?? ""
            let authKey = tokenService.getAuthorizationHeader()?.key ?? "Authorization"
            
            /*  let payload: [String : any JSONEncodable] = [
             "id": "key-cf23-4cb8-9fcb-152ae4fd1e69",
             "payload" : [
             "data": "{\"query\":\"subscription onMiraAdd {\\n miraAdded {\\n __typename\\n id\\n }\\n }\",\"variables\":{}}",
             "extensions": extensionDict
             ],
             "type": "start"
             
             ]*/
            if autoPersistQuery {
                
                body[PayloadKey.extensions.rawValue] = [
                    "persistedQuery": ["sha256Hash": operationIdentifier, "version": 1],
                    PayloadKey.authorization.rawValue: [
                        authKey: authToken,
                        "host": host,
                    ],
                ]
            } else {
                body[PayloadKey.extensions.rawValue] = [
                    PayloadKey.authorization.rawValue: [
                        authKey: authToken,
                        "host": host,
                    ],
                ]
            }
        }
        catch let e {
            print(e.localizedDescription)
        }
        return body
    }
}
