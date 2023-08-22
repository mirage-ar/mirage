// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension MirageAPI {
  class CollectMiraMutation: GraphQLMutation {
    public static let operationName: String = "CollectMira"
    public static let document: ApolloAPI.DocumentType = .notPersisted(
      definition: .init(
        #"""
        mutation CollectMira($collectMiraInput: CollectMiraInput!) {
          collectMira(input: $collectMiraInput) {
            __typename
            id
          }
        }
        """#
      ))

    public var collectMiraInput: CollectMiraInput

    public init(collectMiraInput: CollectMiraInput) {
      self.collectMiraInput = collectMiraInput
    }

    public var __variables: Variables? { ["collectMiraInput": collectMiraInput] }

    public struct Data: MirageAPI.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("collectMira", CollectMira?.self, arguments: ["input": .variable("collectMiraInput")]),
      ] }

      public var collectMira: CollectMira? { __data["collectMira"] }

      /// CollectMira
      ///
      /// Parent Type: `Mira`
      public struct CollectMira: MirageAPI.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Mira }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("id", MirageAPI.ID.self),
        ] }

        public var id: MirageAPI.ID { __data["id"] }
      }
    }
  }

}