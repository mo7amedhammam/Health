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
        
        // Optional: force layout direction
        let selectedLang = Helper.shared.getLanguage()
        UIView.appearance().semanticContentAttribute = selectedLang == "ar" ? .forceRightToLeft : .forceLeftToRight
        UITableView.appearance().semanticContentAttribute = selectedLang == "ar" ? .forceRightToLeft : .forceLeftToRight
        UITabBar.appearance().semanticContentAttribute = selectedLang == "ar" ? .forceRightToLeft : .forceLeftToRight
    
        if !Helper.shared.isLanguageSelected(){ //swiftui
            let vc = UIHostingController(rootView: SelectLanguageView())
            let nav = UINavigationController(rootViewController: vc)
            nav.navigationBar.isHidden = true
            window?.rootViewController = nav
            
        }else if !Helper.shared.checkOnBoard() { //swiftui
            let vc = UIHostingController(rootView: OnboardingView())
            let nav = UINavigationController(rootViewController: vc)
            nav.navigationBar.isHidden = true
            window?.rootViewController = nav
            
        } else { //uikit
            
            if Helper.shared.CheckIfLoggedIn(){ //swiftui
//                let vc = UIHostingController(rootView: NewTabView())
//                let nav = UINavigationController(rootViewController: vc)
//                nav.navigationBar.isHidden = true
//                window?.rootViewController = nav
            
            
                let initialVC: UIViewController = initiateViewController(storyboardName: .main, viewControllerIdentifier: HTBC.self)!

            let nav = UINavigationController(rootViewController: initialVC)
            nav.navigationBar.isHidden = true
            window?.rootViewController = nav
            
            }else  { //swiftui
//                let initialVC: UIViewController = Helper.shared.CheckIfLoggedIn()
//                ? initiateViewController(storyboardName: .main, viewControllerIdentifier: HTBC.self)!
//                : initiateViewController(storyboardName: .main, viewControllerIdentifier: LoginVC.self)!
                
                
                let initialVC: UIViewController = initiateViewController(storyboardName: .main, viewControllerIdentifier: LoginVC.self)!
                
                let nav = UINavigationController(rootViewController: initialVC)
                nav.navigationBar.isHidden = true
                window?.rootViewController = nav
            }
        }
        
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

extension SceneDelegate {
    func reloadRootView() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            let window = UIWindow(windowScene: windowScene)
            window.overrideUserInterfaceStyle = .light
            
            // Configure RTL/LTR direction for the entire app
            self.configureAppWideSemanticContentAttributes()

            
            if !Helper.shared.isLanguageSelected() {
                let vc = UIHostingController(rootView: SelectLanguageView())
                let nav = UINavigationController(rootViewController: vc)
                nav.navigationBar.isHidden = true
                window.rootViewController = nav
                
            } else if !Helper.shared.checkOnBoard() {
                let vc = UIHostingController(rootView: OnboardingView())
                let nav = UINavigationController(rootViewController: vc)
                nav.navigationBar.isHidden = true
                window.rootViewController = nav
            } else {
                if Helper.shared.CheckIfLoggedIn(){ //swiftui
                    //                let vc = UIHostingController(rootView: NewTabView())
                    //                let nav = UINavigationController(rootViewController: vc)
                    //                nav.navigationBar.isHidden = true
                    //                window?.rootViewController = nav
                    
                    
                    let initialVC: UIViewController = initiateViewController(storyboardName: .main, viewControllerIdentifier: HTBC.self)!
                    
                    let nav = UINavigationController(rootViewController: initialVC)
                    nav.navigationBar.isHidden = true
                    window.rootViewController = nav
                    
                }else  { //swiftui
                    //                let initialVC: UIViewController = Helper.shared.CheckIfLoggedIn()
                    //                ? initiateViewController(storyboardName: .main, viewControllerIdentifier: HTBC.self)!
                    //                : initiateViewController(storyboardName: .main, viewControllerIdentifier: LoginVC.self)!
                    
                    
                    let initialVC: UIViewController = initiateViewController(storyboardName: .main, viewControllerIdentifier: LoginVC.self)!
                    
                    let nav = UINavigationController(rootViewController: initialVC)
                    nav.navigationBar.isHidden = true
                    window.rootViewController = nav
                }
                
            }
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    private func configureAppWideSemanticContentAttributes() {
        let isRTL = Helper.shared.getLanguage() == "ar"
        let semanticAttribute: UISemanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
        
        // Apply to all UI components
        UIView.appearance().semanticContentAttribute = semanticAttribute
        UIWindow.appearance().semanticContentAttribute = semanticAttribute
        UINavigationBar.appearance().semanticContentAttribute = semanticAttribute
        UITabBar.appearance().semanticContentAttribute = semanticAttribute
        UIToolbar.appearance().semanticContentAttribute = semanticAttribute
        UITableView.appearance().semanticContentAttribute = semanticAttribute
        UICollectionView.appearance().semanticContentAttribute = semanticAttribute
        UIScrollView.appearance().semanticContentAttribute = semanticAttribute
        
        // Text alignment for labels and text fields
//        UILabel.appearance().textAlignment = isRTL ? .right : .left
        UITextField.appearance().textAlignment = isRTL ? .right : .left
        UITextView.appearance().textAlignment = isRTL ? .right : .left
        
        // For segmented control
        UISegmentedControl.appearance().semanticContentAttribute = semanticAttribute
    }
}

