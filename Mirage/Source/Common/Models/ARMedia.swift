//
//  ARMedia.swift
//  Mirage
//
//  Created by fiigmnt on 6/30/23.
//

import Foundation
import ApolloAPI

typealias ARMediaContentType = MirageAPI.ContentType
typealias ShapeType = MirageAPI.Shape
typealias ModifierType = MirageAPI.ModifierType

extension ARMediaContentType {
    static func withGraphEnum( _ type: GraphQLEnum<ARMediaContentType>) -> ARMediaContentType {
        return ARMediaContentType(rawValue: type.rawValue) ?? .video
    }
}

extension ShapeType {
    static func withGraphEnum( _ type: GraphQLEnum<ShapeType>) -> ShapeType{
        return ShapeType(rawValue: type.rawValue) ?? .plane
    }
}

extension ModifierType {
    static func withGraphEnum( _ type: GraphQLEnum<ModifierType>) -> ModifierType{
        return ModifierType(rawValue: type.rawValue) ?? .none
    }
}


struct ARMedia {
    let id = UUID()
    let contentType: ARMediaContentType
    let assetUrl: String
    let shape: ShapeType
    let modifier: ModifierType
    let position: SIMD3<Float>
}
