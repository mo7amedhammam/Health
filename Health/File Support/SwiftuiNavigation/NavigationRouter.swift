//
//  NavigationRouter.swift
//  Sehaty
//
//  Created by mohamed hammam on 08/07/2025.
//



import SwiftUI
import Combine

final class NavigationRouter: ObservableObject {
    static let shared = NavigationRouter()
    @Published var destination: AnyView? = nil
    @Published var isActive: Bool = false

    func push<V: View>(_ view: V) {
        self.destination = AnyView(view)
        self.isActive = true
    }

    func reset() {
        self.destination = nil
        self.isActive = false
    }
}
struct NavigationHandlerModifier: ViewModifier {
    @ObservedObject var router: NavigationRouter

    func body(content: Content) -> some View {
        ZStack {
            content
            NavigationLink(
                destination: router.destination,
                isActive: $router.isActive,
                label: { EmptyView() }
            )
        }
    }
}

extension View {
    func withNavigation(router: NavigationRouter) -> some View {
        self.modifier(NavigationHandlerModifier(router: router))
    }
}


//MARK: ---- Usage ----
//@StateObject var router = NavigationRouter()
//
//VStack {
//    // UI
//}
//.withNavigation(router: router)
//
//Action:
//router.push(MeasurementDetailsView(stat: stat))
