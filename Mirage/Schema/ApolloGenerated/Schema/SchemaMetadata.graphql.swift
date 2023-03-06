// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public protocol Mirage/Schema/schema.json_SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == Mirage/Schema/schema.json.SchemaMetadata {}

public protocol Mirage/Schema/schema.json_InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == Mirage/Schema/schema.json.SchemaMetadata {}

public protocol Mirage/Schema/schema.json_MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == Mirage/Schema/schema.json.SchemaMetadata {}

public protocol Mirage/Schema/schema.json_MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == Mirage/Schema/schema.json.SchemaMetadata {}

public extension Mirage/Schema/schema.json {
  typealias ID = String

  typealias SelectionSet = Mirage/Schema/schema.json_SelectionSet

  typealias InlineFragment = Mirage/Schema/schema.json_InlineFragment

  typealias MutableSelectionSet = Mirage/Schema/schema.json_MutableSelectionSet

  typealias MutableInlineFragment = Mirage/Schema/schema.json_MutableInlineFragment

  enum SchemaMetadata: ApolloAPI.SchemaMetadata {
    public static let configuration: ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

    public static func objectType(forTypename typename: String) -> Object? {
      switch typename {
      case "Mutation": return Mirage/Schema/schema.json.Objects.Mutation
      case "AuthorizationResult": return Mirage/Schema/schema.json.Objects.AuthorizationResult
      case "User": return Mirage/Schema/schema.json.Objects.User
      default: return nil
      }
    }
  }

  enum Objects {}
  enum Interfaces {}
  enum Unions {}

}