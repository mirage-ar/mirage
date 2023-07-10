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

struct ARMedia {
    let id = UUID()
    let contentType: ARMediaContentType
    let assetUrl: String
    let shape: ShapeType
    let modifier: ModifierType
    let position: SIMD3<Float>
}
