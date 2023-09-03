//
//  UiWindow.swift
//  Health
//
//  Created by wecancity on 03/09/2023.
//

import UIKit
extension UIWindow {
    
    /// Transition to view controller with animation. If no rootViewController is set on the window already,
    /// then it is set, UIWindow.makeKeyAndVisibile() is called, and no animation is needed.
    ///
    /// - Parameter vc: view controller to present
    func replaceRootViewController(_ rootViewController: UIViewController) {
        
        // if rootViewController isn't set yet. Just set it instead of animating the change
        if self.rootViewController == nil {
            self.rootViewController = rootViewController
            self.makeKeyAndVisible()
            return
        }
        
        let transition = CATransition()
        transition.type = CATransitionType.push
        
        layer.add(transition, forKey: kCATransition)
        
        if let vc = self.rootViewController {
            vc.dismiss(animated: false, completion: nil)
        }
        self.rootViewController = rootViewController
    }
}
