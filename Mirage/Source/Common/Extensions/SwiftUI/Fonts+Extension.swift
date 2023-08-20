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
    case title1
    case title2
    case title3
    case subtitle1
    case subtitle2
    case body
    case bodyUpper
    case body12
    case caption1
    case caption2
    case button
    case custom(FontConvertible, CGFloat)

    var letterSpacing: CGFloat {
        switch self {
        case .h1:
            return 2.5
        case .h2, .h3, .title1, .title2, .title3, .subtitle1, .subtitle2, .button, .body, .bodyUpper, .caption1, .body12:
            return 0
        default:
            return 0
        }
    }

    var lineHeight: CGFloat {
        return size * 0.1 + size
    }

    private var textLineHeight: CGFloat {
        return size * 1.5
    }

    var size: CGFloat {
        switch self {
        case .h1: //display 1 in design
            return 48
        case .h2: //display 2 in design
            return 36
        case .h3://display 3 in design
            return 28
        case .subtitle1:
            return 20
        case .subtitle2:
            return 20
        case .title1:
            return 18
        case .title2:
            return 20
        case .title3:
            return 20
        case .body:
            return 16
        case .bodyUpper:
            return 14
        case .body12:
            return 12
        case .caption1:
            return 16
        case .caption2:
            return 16
        case .button:
            return 20
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
        case .custom(let font, let size):
            return font.just(size: size)
        default:
            return DiaTypeMono.regular.just(size: type.size)
        }
    }
    
    static func customUIKit(type: FontType) -> UIFont {
        switch type {
        case .custom(let font, let size):
            return font.font(size: size)
        default:
            return DiaTypeMono.regular.font(size: type.size)

        }

    }
}

extension FontConvertible {
    func just(size: CGFloat) -> SwiftUI.Font {
        SwiftUI.Font.custom(self.name, size: size)
    }
}
