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
    static var label = UILabel()

    class func showHud(in view: UIView, text: String? = nil) {
        activity = UIActivityIndicatorView(frame: CGRect(x: (view.frame.width / 2) - 50, y: (view.frame.height / 2) - 50, width: 100, height: 100))
        activity.style = .medium
        activity.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        activity.startAnimating()
        activity.layer.cornerRadius = 10
        view.isUserInteractionEnabled = false
        view.addSubview(activity)

        if let labelText = text {
            label = UILabel(frame: CGRect(x: 0, y: activity.frame.maxY + 10, width: view.frame.width, height: 20))
            label.textAlignment = .center
            label.textColor = UIColor.darkGray
            label.font = UIFont.systemFont(ofSize: 14)
            label.text = labelText
            view.addSubview(label)
        }
    }
    class func updateProgress(_ newtext: String) {
           label.text = newtext
       }


    class func dismiss(from view: UIView) {
        view.isUserInteractionEnabled = true
        activity.stopAnimating()
        activity.hidesWhenStopped = true
        activity.removeFromSuperview()

        label.removeFromSuperview()
    }
}
