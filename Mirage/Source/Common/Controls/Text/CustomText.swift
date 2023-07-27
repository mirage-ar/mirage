//
//  CustomText.swift
//  Mirage
//
//  Created by Saad on 24/03/2023.
//

import SwiftUI

struct CustomText: View {
    private let text: Text

    private let font: FontType
    private let color: Color
    private let textAlignment: TextAlignment?

    private let letterSpacing: CGFloat
    private let lineSpacing: CGFloat

    var body: some View {
        if let textAlignment = textAlignment {
            textView
                .multilineTextAlignment(textAlignment)
        } else {
            textView
        }
    }

    private var textView: some View {
        text
            .tracking(letterSpacing)
            .lineSpacing(lineSpacing)
            .font(font, color: color)
    }

    init(_ value: String,
         font: FontType = .subtitle2,
         color: Color = Colors.white.just,
         alignment: TextAlignment? = nil,
         isUnderlined: Bool = false,
         letterSpacing: CGFloat = 0,
         lineSpacing: CGFloat? = nil
    ) {
        let text = Text(value)

        self.text = isUnderlined ? text.underline(true,
                                                  color: color) : text

        self.textAlignment = alignment
        self.font = font
        self.color = color
        self.letterSpacing = letterSpacing > 0 ? letterSpacing : font.letterSpacing / 100
        if let lineSpacing = lineSpacing {
            self.lineSpacing = lineSpacing
        } else {
            self.lineSpacing = font.lineHeight
        }
    }
}
