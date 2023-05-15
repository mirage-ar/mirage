//
//  View+Extension.swift
//  Mirage
//
//  Created by Saad on 24/03/2023.
//

import SwiftUI

extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
    
    func font(_ font: FontType = .subtitle2, color: Color = Colors.white.just) -> some View {
        self.font(FontConvertible.Font.custom(type: font))
            .foregroundColor(color)
    }
    
    func cornerBackground<S: ShapeStyle, T: ShapeStyle>(
        cornerRadius: CGFloat = 8,
        fill: S,
        border: T,
        borderWidth: CGFloat = 1) -> some View {
            self.background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(border, lineWidth: borderWidth)
            )
            .cornerBackground(cornerRadius: cornerRadius,
                              fill: fill)
        }
    
    func cornerBackground<S: ShapeStyle>(
        cornerRadius: CGFloat = 8,
        fill: S,
        opacity: Double = 1) -> some View {
            self.background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(fill)
            )
            .opacity(opacity)
            .cornerRadius(cornerRadius)
        }
    
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
    
    func hiddenConditionally(isHidden: Bool) -> some View {
        isHidden ? AnyView(self.hidden()) : AnyView(self)
    }
    
    
}
