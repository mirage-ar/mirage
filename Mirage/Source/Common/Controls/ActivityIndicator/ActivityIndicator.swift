//
//  ActivityIndicator.swift
//  Mirage
//
//  Created by Saad on 24/03/2023.
//

import SwiftUI

struct ActivityIndicator: View {
    private let color: Color

    private let size: CGFloat
    private let curveWidth: CGFloat

    @StateObject private var viewModel = ActivityIndicatorViewModel()

    var body: some View {
        ZStack(alignment: .trailing) {
            Circle()
                .mask(CircleMaskView(curveWidth: curveWidth))

            Circle()
                .fill(color)
                .frame(width: curveWidth, height: curveWidth)
        }
        .frame(maxWidth: .maxActivityIndicatorSize,
               maxHeight: .maxActivityIndicatorSize)
        .frame(width: size,
               height: size)
        .rotationEffect(viewModel.viewRotationEffect)
        .onAppear {
            viewModel.handleViewAppear()
        }
    }

    init(color: Color = Colors.g3Grey.just,
         size: CGFloat = .defaultActivityIndicatorSize) {
        self.color = color

        self.size = size
        self.curveWidth = size * 0.09
    }
}

private struct CircleMaskView: View {
    let curveWidth: CGFloat

    var body: some View {
        ZStack {
            // White mask is opaque
            Circle()
                .fill(Color.white)

            // Black mask is transparent
            Circle()
                .fill(Color.black)
                .padding(curveWidth)
        }
        .compositingGroup()
        .luminanceToAlpha()
    }
}

private class ActivityIndicatorViewModel: ObservableObject {

    @Published var isAnimating: Bool = false

    var viewRotationEffect: Angle {
        !isAnimating ? .degrees(0) : .degrees(360)
    }

    let viewAnimation: Animation =
        .linear(duration: .spinAnimationDuration).repeatForever(autoreverses: false)

    /// Performs actions when a view appears
    func handleViewAppear() {
        // A fix to remove a 'jumping' effect in the animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(self.viewAnimation) {
                self.isAnimating = true
            }
        }
    }
}

private extension CGFloat {
    static var defaultActivityIndicatorSize: CGFloat = 32
    static var maxActivityIndicatorSize: CGFloat = 92

    static var activityIndicatorCurveWidthCoefficient: CGFloat = 0.09
}

private extension Double {
    static var spinAnimationDuration = 1.5
}

// MARK: - Preview

struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicator()
    }
}
