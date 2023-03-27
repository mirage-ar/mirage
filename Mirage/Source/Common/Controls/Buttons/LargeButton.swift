//
//  LargeButton.swift
//  Mirage
//
//  Created by Saad on 24/03/2023.
//

import SwiftUI
import CoreGraphics

private extension CGFloat {
    static var buttonHorizontalMargins: CGFloat = 0
}

struct LargeButton: View {
    @Binding var loading: Bool

    private enum Action {
        case action(() -> Void)
        case navigate(screen: NavigationRoute)
    }

    private var buttonView: AnyView
    private let buttonStyle: LargeButtonStyle

    private let action: Action

    private let disabled: Bool

    // MARK: Action inits

    init(title: String,
         disabled: Bool = false,
         isFilled: Bool = true,
         height: CGFloat = 48,
         maxWidth: CGFloat? = .infinity,
         loading: Binding<Bool> = .constant(false),
         action: @escaping () -> Void) {
        self.init(title: title,
                  disabled: disabled,
                  isFilled: isFilled,
                  height: height,
                  maxWidth: maxWidth,
                  buttonAction: .action(action),
                  loading: loading)
    }

    init(image: Image,
         disabled: Bool = false,
         isFilled: Bool = true,
         height: CGFloat = 48,
         maxWidth: CGFloat? = .infinity,
         loading: Binding<Bool> = .constant(false),
         action: @escaping () -> Void) {
        self.init(buttonView: image.eraseToAnyView(),
                  disabled: disabled,
                  isFilled: isFilled,
                  height: height,
                  maxWidth: maxWidth,
                  buttonAction: .action(action),
                  loading: loading)
    }

    init(buttonView: AnyView,
         disabled: Bool = false,
         disabledBackground: Bool = false,
         isFilled: Bool = true,
         height: CGFloat = 48,
         maxWidth: CGFloat? = .infinity,
         loading: Binding<Bool> = .constant(false),
         action: @escaping () -> Void) {
       self.init(buttonView: buttonView,
                 disabled: disabled,
                 disabledBackground: disabledBackground,
                 isFilled: isFilled,
                 height: height,
                 maxWidth: maxWidth,
                 buttonAction: .action(action),
                 loading: loading)
    }

    // MARK: Navigation inits

    init(title: String,
         disabled: Bool = false,
         isFilled: Bool = true,
         height: CGFloat = 48,
         maxWidth: CGFloat? = .infinity,
         navigationRoute: NavigationRoute,
         loading: Binding<Bool> = .constant(false)) {
        self.init(title: title,
                  disabled: disabled,
                  isFilled: isFilled,
                  height: height,
                  maxWidth: maxWidth,
                  buttonAction: .navigate(screen: navigationRoute),
                  loading: loading)
    }

    init(image: Image,
         disabled: Bool = false,
         isFilled: Bool = true,
         height: CGFloat = 48,
         maxWidth: CGFloat? = .infinity,
         navigationRoute: NavigationRoute,
         loading: Binding<Bool> = .constant(false)) {
        self.init(buttonView: image.eraseToAnyView(),
                  disabled: disabled,
                  isFilled: isFilled,
                  height: height,
                  maxWidth: maxWidth,
                  buttonAction: .navigate(screen: navigationRoute),
                  loading: loading)
    }

    init(buttonView: AnyView,
         disabled: Bool = false,
         isFilled: Bool = true,
         height: CGFloat = 48,
         maxWidth: CGFloat? = .infinity,
         navigationRoute: NavigationRoute,
         loading: Binding<Bool> = .constant(false)) {
        self.init(buttonView: buttonView,
                  disabled: disabled,
                  isFilled: isFilled,
                  height: height,
                  maxWidth: maxWidth,
                  buttonAction: .navigate(screen: navigationRoute),
                  loading: loading)
    }

    // MARK: Private inits

    private init(title: String,
                 disabled: Bool = false,
                 isFilled: Bool = true,
                 height: CGFloat = 48,
                 maxWidth: CGFloat? = .infinity,
                 buttonAction: Action,
                 loading: Binding<Bool> = .constant(false)) {
        let buttonView = CustomText(title,
                                    font: .button,
                                    color: isFilled ? Colors.g1DarkGrey.just : Colors.white.just)
            .frame(maxWidth: maxWidth)
            .eraseToAnyView()

        self.init(buttonView: buttonView,
                  disabled: disabled,
                  isFilled: isFilled,
                  height: height,
                  maxWidth: maxWidth,
                  buttonAction: buttonAction,
                  loading: loading)
    }

    private init(buttonView: AnyView,
                 disabled: Bool = false,
                 disabledBackground: Bool = false,
                 isFilled: Bool = true,
                 height: CGFloat = 48,
                 maxWidth: CGFloat? = .infinity,
                 buttonAction: Action,
                 loading: Binding<Bool> = .constant(false)) {
        self.buttonView = buttonView
        self.buttonStyle = LargeButtonStyle(height: height,
                                            maxWidth: maxWidth,
                                            isFilled: isFilled,
                                            isDisabled: disabled || disabledBackground)

        self.action = buttonAction

        self.disabled = disabled

        self._loading = loading
    }

    // MARK: UI

    var body: some View {
        let buttonView = loading ? activityIndicator : self.buttonView

        Group {
            switch self.action {
            case .action(let action):
                Button(action: action) {
                    buttonView
                }
                .buttonStyle(buttonStyle)

            case .navigate(let screen):
                buttonView
                    .navigate(to: screen, buttonStyle: buttonStyle)
            }
        }
        .disabled(self.disabled)
        .padding(.horizontal, .buttonHorizontalMargins)
    }

    private var activityIndicator: AnyView {
        let size = buttonStyle.height - .buttonActivityIndicatorVerticalPadding

        return ActivityIndicator(color: buttonStyle.isFilled ? Colors.g1DarkGrey.just : Colors.g4LightGrey.just, size: size)
            .eraseToAnyView()
    }
}

private extension CGFloat {
    static let buttonActivityIndicatorVerticalPadding = 10.25 * 2
}
