//
//  ARMedia.swift
//  Mirage
//
//  Created by fiigmnt on 6/30/23.
//

import Foundation
import ApolloAPI

typealias ARMediaContentType = GraphQLEnum<MirageAPI.ContentType>
typealias ShapeType = GraphQLEnum<MirageAPI.Shape>
typealias ModifierType = GraphQLEnum<MirageAPI.ModifierType>

//enum ARMediaContentType {
//    case PHOTO
//    case VIDEO
//}
//
//enum ShapeType {
//    case PLANE
//    case CUBE
//    case SPHERE
//}
//
//enum ModifierType {
//    case NONE
//    case TRANSPARENCY
//    case SPIN
//}

struct ARMedia {
    let id = UUID()
    let contentType: ARMediaContentType
    let assetUrl: String
    let shape: ShapeType
    let modifier: ModifierType
    let position: SIMD3<Float>
}
