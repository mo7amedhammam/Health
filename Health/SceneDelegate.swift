//
//  SceneDelegate.swift
//  Health
//
//  Created by Hamza on 27/07/2023.
//

import UIKit
import SwiftUI
import Combine

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var chatRouterObserver: Any?

    // MARK: - Scene lifecycle
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {

        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        window.overrideUserInterfaceStyle = .light

        window.rootViewController = makeRootViewController()
        window.makeKeyAndVisible()
        self.window = window

        observeChatDeepLink()
        observeAppRouter()
    }
}

private extension SceneDelegate {

    func makeRootViewController() -> UIViewController {

        // 1️⃣ Language
        if !Helper.shared.isLanguageSelected() {
            return host(SelectLanguageView())
        }

        // 2️⃣ Onboarding
        if !Helper.shared.checkOnBoard() {
            return host(OnboardingView())
        }

        // 3️⃣ Logged in
        if Helper.shared.CheckIfLoggedIn() {
            return mainTabs()
        }

        // 4️⃣ Not logged in
        Helper.shared.setSelectedUserType(userType: .Customer)

        if Helper.shared.AppCountryId() != nil {
            return mainTabs()
        }

        return host(LoginView())
    }
}

private extension SceneDelegate {

    func mainTabs() -> UIViewController {

        let rootView: AnyView

        if Helper.shared.getSelectedUserType() == .Doctor {
            rootView = AnyView(
                DocTabView()
                    .environmentObject(EditProfileViewModel.shared)
            )
        } else {
            rootView = AnyView(
                NewTabView()
                    .environmentObject(EditProfileViewModel.shared)
            )
        }

        return host(rootView)
    }
}

private extension SceneDelegate {

    func host<V: View>(_ view: V) -> UIViewController {
        let hosting = UIHostingController(rootView: view)
        let nav = UINavigationController(rootViewController: hosting)
        nav.navigationBar.isHidden = true
        return nav
    }
}

private extension SceneDelegate {

    func observeChatDeepLink() {
        NotificationCenter.default.addObserver(
            forName: .openChatFromNotification,
            object: nil,
            queue: .main
        ) { notification in

            guard
                let packageIdString = notification.userInfo?["customerPackageId"] as? String,
                let packageId = Int(packageIdString)
            else { return }

            ChatsViewModel.shared.configure(customerPackageId: packageId)
            AppRouter.shared.openChat(packageId: packageId)
        }
    }
}

private extension SceneDelegate {

    func observeAppRouter() {
        // Observe AppRouter.activeChatPackageId changes using KVO-compliant notification
        chatRouterObserver = AppRouter.shared.observe(\.$activeChatPackageId) { [weak self] id in
            guard let self = self else { return }
            guard let packageId = id else { return }
            self.pushChat(packageId: packageId)
        }
    }

    func pushChat(packageId: Int) {
        // Configure the view model before presenting
        ChatsViewModel.shared.configure(customerPackageId: packageId)

        // Find the topmost navigation controller
        guard let nav = topNavigationController() else { return }

        // If a ChatsView for the same package is already visible, do nothing
        if let top = nav.topViewController as? UIHostingController<ChatsView> {
            // No generic equality available; rely on resetting router to prevent loops
            AppRouter.shared.reset()
            return
        }

        let chatVC = UIHostingController(rootView: ChatsView(CustomerPackageId: packageId))
        chatVC.hidesBottomBarWhenPushed = true
        nav.pushViewController(chatVC, animated: true)
        AppRouter.shared.reset()
    }

    func topNavigationController(base: UIViewController? = nil) -> UINavigationController? {
        let baseVC = base ?? window?.rootViewController
        if let nav = baseVC as? UINavigationController { return nav }
        if let tab = baseVC as? UITabBarController {
            return topNavigationController(base: tab.selectedViewController)
        }
        if let presented = baseVC?.presentedViewController {
            return topNavigationController(base: presented)
        }
        if let hosting = baseVC as? UIHostingController<AnyView> {
            return hosting.navigationController
        }
        return baseVC?.navigationController
    }
}

final class AppRouter: ObservableObject {

    static let shared = AppRouter()

    @Published var activeChatPackageId: Int? = nil

    func openChat(packageId: Int) {
        activeChatPackageId = packageId
    }

    func reset() {
        activeChatPackageId = nil
    }

    // Simple observation helper for UIKit land (iOS 15 friendly)
    func observe(_ keyPath: KeyPath<AppRouter, Published<Int?>.Publisher>, _ handler: @escaping (Int?) -> Void) -> Any {
        let cancellable = self.$activeChatPackageId.sink { value in
            handler(value)
        }
        return cancellable as Any
    }
}
