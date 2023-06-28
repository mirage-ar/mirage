// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public protocol MirageAPI_SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == MirageAPI.SchemaMetadata {}

public protocol MirageAPI_InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == MirageAPI.SchemaMetadata {}

public protocol MirageAPI_MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == MirageAPI.SchemaMetadata {}

public protocol MirageAPI_MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == MirageAPI.SchemaMetadata {}

public extension MirageAPI {
  typealias ID = String

  typealias SelectionSet = MirageAPI_SelectionSet

  typealias InlineFragment = MirageAPI_InlineFragment

  typealias MutableSelectionSet = MirageAPI_MutableSelectionSet

  typealias MutableInlineFragment = MirageAPI_MutableInlineFragment

  enum SchemaMetadata: ApolloAPI.SchemaMetadata {
    public static let configuration: ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

    public static func objectType(forTypename typename: String) -> Object? {
      switch typename {
      case "Mutation": return MirageAPI.Objects.Mutation
      case "AuthorizationResult": return MirageAPI.Objects.AuthorizationResult
      case "User": return MirageAPI.Objects.User
      case "Query": return MirageAPI.Objects.Query
      case "Mira": return MirageAPI.Objects.Mira
      case "Location": return MirageAPI.Objects.Location
      case "VerificationResult": return MirageAPI.Objects.VerificationResult
      default: return nil
      }
    }
  }

  enum Objects {}
  enum Interfaces {}
  enum Unions {}

}