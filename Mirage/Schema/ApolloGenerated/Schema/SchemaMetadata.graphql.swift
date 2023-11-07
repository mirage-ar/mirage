// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

protocol MirageAPI_SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == MirageAPI.SchemaMetadata {}

protocol MirageAPI_InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == MirageAPI.SchemaMetadata {}

protocol MirageAPI_MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == MirageAPI.SchemaMetadata {}

protocol MirageAPI_MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == MirageAPI.SchemaMetadata {}

extension MirageAPI {
  typealias ID = String

  typealias SelectionSet = MirageAPI_SelectionSet

  typealias InlineFragment = MirageAPI_InlineFragment

  typealias MutableSelectionSet = MirageAPI_MutableSelectionSet

  typealias MutableInlineFragment = MirageAPI_MutableInlineFragment

  enum SchemaMetadata: ApolloAPI.SchemaMetadata {
    static let configuration: ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

    static func objectType(forTypename typename: String) -> Object? {
      switch typename {
      case "Mutation": return MirageAPI.Objects.Mutation
      case "FriendRequest": return MirageAPI.Objects.FriendRequest
      case "AuthorizationResult": return MirageAPI.Objects.AuthorizationResult
      case "User": return MirageAPI.Objects.User
      case "Mira": return MirageAPI.Objects.Mira
      case "ArMedia": return MirageAPI.Objects.ArMedia
      case "Modifier": return MirageAPI.Objects.Modifier
      case "Position": return MirageAPI.Objects.Position
      case "Location": return MirageAPI.Objects.Location
      case "VerificationResult": return MirageAPI.Objects.VerificationResult
      case "Query": return MirageAPI.Objects.Query
      case "Subscription": return MirageAPI.Objects.Subscription
      default: return nil
      }
    }
  }

  enum Objects {}
  enum Interfaces {}
  enum Unions {}

}