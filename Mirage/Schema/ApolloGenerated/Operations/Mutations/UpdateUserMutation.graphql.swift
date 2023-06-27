// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension MirageAPI {
    class UpdateUserMutation: GraphQLMutation {
        static let operationName: String = "UpdateUser"
        static let document: ApolloAPI.DocumentType = .notPersisted(
            definition: .init(
                #"""
                mutation UpdateUser($updateUserInput: UpdateUserInput!) {
                  updateUser(input: $updateUserInput) {
                    __typename
                    id
                    username
                  }
                }
                """#
            ))

        public var updateUserInput: UpdateUserInput

        public init(updateUserInput: UpdateUserInput) {
            self.updateUserInput = updateUserInput
        }

        public var __variables: Variables? { ["updateUserInput": updateUserInput] }

        struct Data: MirageAPI.SelectionSet {
            let __data: DataDict
            init(data: DataDict) { __data = data }

            static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Mutation }
            static var __selections: [ApolloAPI.Selection] { [
                .field("updateUser", UpdateUser?.self, arguments: ["input": .variable("updateUserInput")]),
            ] }

            var updateUser: UpdateUser? { __data["updateUser"] }

            /// UpdateUser
            ///
            /// Parent Type: `User`
            struct UpdateUser: MirageAPI.SelectionSet {
                let __data: DataDict
                init(data: DataDict) { __data = data }

                static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.User }
                static var __selections: [ApolloAPI.Selection] { [
                    .field("__typename", String.self),
                    .field("id", MirageAPI.ID.self),
                    .field("username", String.self),
                ] }

                var id: MirageAPI.ID { __data["id"] }
                var username: String { __data["username"] }
            }
        }
    }
}
