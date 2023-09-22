// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension MirageAPI {
  class CollectMiraMutation: GraphQLMutation {
    static let operationName: String = "CollectMira"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation CollectMira($collectMiraInput: CollectMiraInput!) { collectMira(input: $collectMiraInput) { __typename id } }"#
      ))

    public var collectMiraInput: CollectMiraInput

    public init(collectMiraInput: CollectMiraInput) {
      self.collectMiraInput = collectMiraInput
    }

    public var __variables: Variables? { ["collectMiraInput": collectMiraInput] }

    struct Data: MirageAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("collectMira", CollectMira?.self, arguments: ["input": .variable("collectMiraInput")]),
      ] }

      var collectMira: CollectMira? { __data["collectMira"] }

      /// CollectMira
      ///
      /// Parent Type: `Mira`
      struct CollectMira: MirageAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Mira }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", MirageAPI.ID.self),
        ] }

        var id: MirageAPI.ID { __data["id"] }
      }
    }
  }

}