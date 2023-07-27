//
//  NavigationElement.swift
//  Mirage
//
//  Created by Saad on 15/03/2023.
//

import SwiftUI


protocol NavigationRouter {
    associatedtype NavigationRoute

    var currentRoute: NavigationRoute? { get }

    func navigate(to route: NavigationRoute)
}

public class AppNavigationRouter: NavigationRouter, ObservableObject {
    @Published public var currentRoute: NavigationRoute?
    @Environment(\.presentationMode) var presentation

    public init() { }

    public func navigate(to route: NavigationRoute) {
        currentRoute = route
    }

    public func popToRoot() {
        // TODO: Find a solution for SwiftUI
        presentation.wrappedValue.dismiss()
    }
}

private struct NavigationElement: ViewModifier {
    let route: NavigationRoute

    func body(content: Content) -> some View {
        NavigationLink(destination: route.screen) {
            content
        }
        .buttonStyle(PlainButtonStyle())
    }
}

private struct StyledNavigationElement<Style: ButtonStyle>: ViewModifier {
    let route: NavigationRoute
    let buttonStyle: Style

    func body(content: Content) -> some View {
        NavigationLink(destination: route.screen) {
            content
        }
        .buttonStyle(buttonStyle)
    }
}

private struct BackNavigationElement: ViewModifier {
    @Environment(\.presentationMode) private var presentationMode

    @Binding var goBack: Bool

    func body(content: Content) -> some View {
        content
            .onChange(of: goBack) {
                guard $0 else { return }

                self.presentationMode.wrappedValue.dismiss()
            }
    }
}

extension View {
    func navigate(to route: NavigationRoute) -> some View {
        modifier(NavigationElement(route: route))
    }
    
    func navigate(to route: NavigationRoute,when binding: Binding<Bool>) -> some View {
        modifier(NavigationElement(route: route))
    }

    
    func navigate<Style: ButtonStyle>(to route: NavigationRoute, buttonStyle: Style) -> some View {
        modifier(StyledNavigationElement(route: route, buttonStyle: buttonStyle))
    }

    /// Navigates to the sprcified route. Use it inside `List` to remove the unnecessary navigation arrow button
    ///
    ///  - parameters:
    ///     - route: A route to be navigated to
    ///
    ///  - returns: A view with an embeded navigation link
    ///
    func navigateFromList(to route: NavigationRoute) -> some View {
        ZStack {
            EmptyView()
                .navigate(to: route)
                .opacity(0)

            self
        }
    }

    func goBack(state: Binding<Bool>) -> some View {
        modifier(BackNavigationElement(goBack: state))
    }
}
