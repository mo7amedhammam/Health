//
//  SceneDelegate.swift
//  Health
//
//  Created by Hamza on 27/07/2023.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        window?.overrideUserInterfaceStyle = .light
        guard let _ = (scene as? UIWindowScene) else { return }
        
////        MARK: -- Programatically --
        guard let WindowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: WindowScene)
//
////        MARK: -- if uikit --
//        var vc : UIViewController = UIViewController()
//        if !Helper.shared.checkOnBoard() {
//            guard let targetvc = initiateViewController(storyboardName: .main, viewControllerIdentifier: SplashScreenVC.self) else {return}
//            vc = targetvc
//        }else{
//            guard let targetvc = initiateViewController(storyboardName: .main, viewControllerIdentifier: Helper.shared.CheckIfLoggedIn() ? HTBC.self : LoginVC.self) else {return}
////            guard let targetvc = initiateViewController(storyboardName: .main, viewControllerIdentifier: ChangePasswordVC.self) else {return}
//
//            vc = targetvc
//        }
//        guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: (Helper.shared.checkOnBoard() ? (Helper.shared.CheckIfLoggedIn() ? HTBC.self : LoginVC.self ) : OnboardingView)) else {return}
        
//        var rootVC: UIViewController
//
//        if !Helper.shared.checkOnBoard() {
//               // If onboarding is not completed, show the SwiftUI OnboardingView inside UIHostingController
//            rootVC = UIHostingController(rootView: OnboardingView())
//           } else {
//               // Decide between HTBC or LoginVC (UIKit views)
//               guard let targetVC = initiateViewController(storyboardName: .main,
//                                                           viewControllerIdentifier: Helper.shared.CheckIfLoggedIn() ? HTBC.self : LoginVC.self)
//               else { return }
//               
//               rootVC = targetVC
//           }

        
//////        MARK: -- if SwiftUI --
//        let rootVC = UIHostingController(rootView: SwiftuiTest())
////
//        let nav = UINavigationController(rootViewController: rootVC)
//        nav.navigationBar.isHidden = true
//        self.window?.rootViewController = nav
//        window?.makeKeyAndVisible()
        
        if !Helper.shared.isLanguageSelected(){
            window?.rootViewController = UIHostingController(rootView: SelectLanguageView())

        }else if !Helper.shared.checkOnBoard() {
              window?.rootViewController = UIHostingController(rootView: OnboardingView())
              
          } else {
              let initialVC: UIViewController = Helper.shared.CheckIfLoggedIn()
                  ? initiateViewController(storyboardName: .main, viewControllerIdentifier: HTBC.self)!
                  : initiateViewController(storyboardName: .main, viewControllerIdentifier: LoginVC.self)!
              
              let nav = UINavigationController(rootViewController: initialVC)
              nav.navigationBar.isHidden = true
              window?.rootViewController = nav
          }
          
//          self.window = window
        window?.makeKeyAndVisible()
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

