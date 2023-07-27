//
//  ButtonStyles.swift
//  Mirage
//
//  Created by Saad on 24/03/2023.
//

import SwiftUI


struct LargeButtonStyle: ButtonStyle {
    let height: CGFloat
    let maxWidth: CGFloat?

    let isFilled: Bool
    let isDisabled: Bool

    func makeBody(configuration: Self.Configuration) -> some View {
        let foregroundColor = !isFilled ? Colors.white.just : .white
        let currentForegroundColor = isDisabled || configuration.isPressed ? foregroundColor.opacity(0.3) : foregroundColor

        let view = configuration.label
            .contentShape(Rectangle())
            .frame(maxWidth: maxWidth)
            .frame(height: height)
            .foregroundColor(currentForegroundColor)

        if isFilled && isDisabled {
            return view.cornerBackground(cornerRadius: 0.0, fill: Colors.g1DarkGrey.just,
                                         border: Color.clear)
                .eraseToAnyView()
        }

        if isFilled {
            return view.cornerBackground(cornerRadius: 0.0, fill: Colors.white.just,
                                         border: Color.clear)
                .eraseToAnyView()
        }

        return view.cornerBackground(cornerRadius: 0.0, fill: Color.clear,
                                     border: Colors.white.just,
                                     borderWidth: 2)
            .eraseToAnyView()
    }
}

struct CircleButtonStyle: ButtonStyle {
    let size: CGFloat

    init(size: CGFloat = 54) {
        self.size = size
    }

    func makeBody(configuration: Self.Configuration) -> some View {
        ZStack {
            Circle()
                .fill(Colors.white.just)

            configuration.label
        }
        .frame(width: size, height: size)
    }
}
