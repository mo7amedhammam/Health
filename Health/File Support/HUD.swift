//
//  HUD.swift
//  Health
//
//  Created by wecancity on 05/09/2023.
//

import UIKit

@available(iOS 13.0, *)
class Hud: NSObject {
    
    static var activity = UIActivityIndicatorView()
    
    class func showHud(in view: UIView){
        
        activity = UIActivityIndicatorView(frame: CGRect(x: (view.frame.width / 2) - 50, y: (view.frame.height / 2) - 50, width: 100, height: 100))
        
        activity.style = .medium
        activity.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        activity.startAnimating()
        activity.layer.cornerRadius = 10
        view.isUserInteractionEnabled = false
        view.addSubview(activity)
        
    }
    
    class func dismiss(from view: UIView){
      
//        DispatchQueue.main.asyncAfter(deadline: .now()) {
        view.isUserInteractionEnabled = true
            activity.stopAnimating()
            activity.hidesWhenStopped = true
            activity.removeFromSuperview()
//        }
    }
    
}
