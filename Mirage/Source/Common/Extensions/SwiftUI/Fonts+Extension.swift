//
//  Fonts+Extension.swift
//  Mirage
//
//  Created by Saad on 24/03/2023.
//

import SwiftUI

enum FontType {
    case h1
    case h2
    case h3
    case subtitle1
    case subtitle2
    case body1
    case body2
    case body3
    case button
    case custom(FontConvertible, CGFloat)

    var letterSpacing: CGFloat {
        switch self {
        case .h1, .h2, .h3, .subtitle1, .subtitle2, .button, .custom:
            return 4
        case .body1, .body2, .body3:
            return 2
        }
    }

    var lineHeight: CGFloat {
        return textLineHeight - size
    }

    private var textLineHeight: CGFloat {
        return size * 1.5
    }

    var size: CGFloat {
        switch self {
        case .h1:
            return 48
        case .h2:
            return 36
        case .h3:
            return 28
        case .subtitle1:
            return 20
        case .subtitle2:
            return 18
        case .body1:
            return 16
        case .body2:
            return 14
        case .body3:
            return 12
        case .button:
            return 18
        case .custom(_, let size):
            return size
        }
    }
}

extension FontConvertible.Font {

    typealias DiaTypeMono = FontFamily.ABCDiatypeMono
//TODO: fix font weight here when fonts are imported
    static func custom(type: FontType) -> Font {
        switch type {
        case .h1:
            return DiaTypeMono.regular.just(size: type.size)
        case .h2:
            return DiaTypeMono.regular.just(size: type.size)
        case .h3:
            return DiaTypeMono.regular.just(size: type.size)
        case .subtitle1:
            return DiaTypeMono.regular.just(size: type.size)
        case .subtitle2:
            return DiaTypeMono.regular.just(size: type.size)
        case .body1:
            return DiaTypeMono.regular.just(size: type.size)
        case .body2:
            return DiaTypeMono.regular.just(size: type.size)
        case .body3:
            return DiaTypeMono.regular.just(size: type.size)
        
        case .button:
            return DiaTypeMono.regular.just(size: type.size)
        case .custom(let font, let size):
            return font.just(size: size)
        }
    }
}

extension FontConvertible {
    func just(size: CGFloat) -> SwiftUI.Font {
        SwiftUI.Font.custom(self.name, size: size)
    }
}
