//
//  Helpers.swift
//  Miras
//
//  Created by fiigmnt on 2/14/23.
//

import SwiftUI
import UIKit
import RealityKit
import ARKit

// SIMD3 typealias
typealias XYZ = SIMD3<Float>

func imageSize(width: Double, height: Double) -> XYZ {
    let aspectRatio = width / height
    
    // most likely a photo
    if aspectRatio > 0.5 {
        return [0.2, Float(aspectRatio * 0.2), 0.01]
    }
    
    // screenshot
    return [Float(aspectRatio * 0.2), 0.2, 0.01]
}

// IMAGE ORIENTATION
func imageOrientation(forDeviceOrientation deviceOrientation: UIDeviceOrientation) -> CGImagePropertyOrientation {
    switch deviceOrientation {
    case .portrait:
        return .right
    case .portraitUpsideDown:
        return .left
    case .landscapeLeft:
        return .up
    case .landscapeRight:
        return .down
    default:
        return .up
    }
}

// IMAGE ROTATION EXTENSION
extension UIImage {
    func rotated(to orientation: UIImage.Orientation) -> UIImage {
        guard let cgImage = cgImage else { return self }

        var transform = CGAffineTransform.identity
        switch orientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -.pi / 2)
        case .up, .upMirrored:
            break
        @unknown default:
            break
        }

        switch orientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default:
            break
        }

        guard let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height),
                                  bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0,
                                  space: cgImage.colorSpace ?? CGColorSpaceCreateDeviceRGB(),
                                  bitmapInfo: cgImage.bitmapInfo.rawValue) else {
            return self
        }
        ctx.concatenate(transform)

        switch orientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(cgImage, in: CGRect(origin: .zero, size: size))
        }

        guard let finalImage = ctx.makeImage() else { return self }
        return UIImage(cgImage: finalImage)
    }
}

// Color HEX Extension
extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

// Matrix math helpers
func distanceBetween(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> CLLocationDistance {
    let location1 = CLLocation(latitude: lat1, longitude: lon1)
    let location2 = CLLocation(latitude: lat2, longitude: lon2)
    return location1.distance(from: location2)
}

func matrix_from_coordinates(distanceNorthSouth: Float, distanceEastWest: Float, elevationDifference: Float) -> matrix_float4x4 {
    var translation = matrix_identity_float4x4
    translation.columns.3.z = -distanceNorthSouth
    translation.columns.3.x = -distanceEastWest
    translation.columns.3.y = elevationDifference
    return translation
}

func rotationMatrixForDegrees(degrees: Float) -> matrix_float4x4 {
    let radians = degrees * (Float.pi / 180.0)

    var matrix = matrix_identity_float4x4
    matrix.columns.0.x = cos(radians)
    matrix.columns.0.z = -sin(radians)
    matrix.columns.2.x = sin(radians)
    matrix.columns.2.z = cos(radians)

    return matrix
}
