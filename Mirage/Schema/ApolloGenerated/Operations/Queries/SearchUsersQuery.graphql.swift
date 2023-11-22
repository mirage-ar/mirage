// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension MirageAPI {
  class SearchUsersQuery: GraphQLQuery {
    static let operationName: String = "SearchUsersQuery"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query SearchUsersQuery($input: GetUsersQueryInput!) { getUsers(input: $input) { __typename id phone username profileImage profileDescription friendshipStatus } }"#
      ))

    public var input: GetUsersQueryInput

    public init(input: GetUsersQueryInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    struct Data: MirageAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("getUsers", [GetUser?]?.self, arguments: ["input": .variable("input")]),
      ] }

      var getUsers: [GetUser?]? { __data["getUsers"] }

      /// GetUser
      ///
      /// Parent Type: `User`
      struct GetUser: MirageAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.User }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", MirageAPI.ID.self),
          .field("phone", String?.self),
          .field("username", String.self),
          .field("profileImage", String?.self),
          .field("profileDescription", String?.self),
          .field("friendshipStatus", GraphQLEnum<MirageAPI.FriendshipStatus>?.self),
        ] }

        var id: MirageAPI.ID { __data["id"] }
        var phone: String? { __data["phone"] }
        var username: String { __data["username"] }
        var profileImage: String? { __data["profileImage"] }
        var profileDescription: String? { __data["profileDescription"] }
        var friendshipStatus: GraphQLEnum<MirageAPI.FriendshipStatus>? { __data["friendshipStatus"] }
      }
    }
  }

}