//
//  HUD.swift
//  Health
//
//  Created by wecancity on 05/09/2023.
//

import UIKit

@available(iOS 13.0, *)
class Hud: NSObject {
    static var activity: UIActivityIndicatorView?
    static var label: UILabel?
    static var isShowing: Bool = false

    class func showHud(in view: UIView, text: String? = nil) {
        if isShowing {
            // HUD is already showing, do nothing
            return
        }

        activity = UIActivityIndicatorView(frame: CGRect(x: (view.frame.width / 2) - 50, y: (view.frame.height / 2) - 50, width: 100, height: 100))
        activity?.style = .medium
        activity?.color = .white
        activity?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        activity?.startAnimating()
        activity?.layer.cornerRadius = 10
        view.isUserInteractionEnabled = false
//        view.backgroundColor = UIColor.black.withAlphaComponent(0.4) // Semi-transparent background
        view.addSubview(activity!)

        if let labelText = text {
            label = UILabel(frame: CGRect(x: 0, y: activity!.frame.maxY + 10, width: view.frame.width, height: 20))
            label?.textAlignment = .center
            label?.textColor = UIColor.white
            label?.font = UIFont.systemFont(ofSize: 14)
            label?.text = labelText
            view.addSubview(label!)

            // Adjust the label's frame to align it with the bottom of the activity indicator
            label?.frame.origin.y = activity!.frame.maxY - 25

            // Adjust the activity indicator's frame to center it relative to the label
            activity?.center.x = label!.center.x
        }

        isShowing = true
    }

    class func updateProgress(_ newtext: String) {
        label?.text = newtext
    }

    class func dismiss(from view: UIView) {
        view.isUserInteractionEnabled = true
        activity?.stopAnimating()
        activity?.hidesWhenStopped = true
        activity?.removeFromSuperview()
        label?.removeFromSuperview()

        // Reset the isShowing flag
        isShowing = false
    }
    
}


import UIKit

class NewHud {
//    static let shared = NewHud()
    private static var activity: UIActivityIndicatorView?
    private static var label: UILabel?
    private static var isShowing: Bool = false

    /// Shows a HUD with an optional text message.
    /// - Parameters:
    ///   - view: The view in which to display the HUD.
    ///   - text: An optional text message to display below the activity indicator.
    static func show(in view: UIView, text: String? = nil) {
        DispatchQueue.main.async {
            
            guard !isShowing else { return } // Prevent multiple HUDs
            
            // Create and configure the activity indicator
            activity = UIActivityIndicatorView(frame: CGRect(x: (view.frame.width / 2) - 50, y: (view.frame.height / 2) - 50, width: 100, height: 100))
            activity?.style = .medium
            activity?.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            activity?.startAnimating()
            activity?.layer.cornerRadius = 10
            view.isUserInteractionEnabled = false
//            view.viewContainingController.b = UIColor.black.withAlphaComponent(0.3) // Semi-transparent background

            // Add the activity indicator to the view
            if let activity = activity {
                view.addSubview(activity)
            }
            
            // Add a label if text is provided
            if let text = text, let activity = activity {
                label = UILabel(frame: CGRect(x: 0, y: activity.frame.maxY + 10, width: view.frame.width, height: 20))
                label?.textAlignment = .center
                label?.textColor = UIColor.white
                label?.font = UIFont.systemFont(ofSize: 14)
                label?.text = text
                view.addSubview(label!)
                
                // Adjust the label's position
                label?.frame.origin.y = activity.frame.maxY - 25
                activity.center.x = label!.center.x
            }
            
            isShowing = true
        }
    }

    /// Updates the text of the HUD label.
    /// - Parameter text: The new text to display.
    static func updateProgress(_ text: String) {
        DispatchQueue.main.async {
            label?.text = text
        }
    }

    /// Dismisses the HUD from the view.
    /// - Parameter view: The view from which to dismiss the HUD.
    static func dismiss(from view: UIView) {
        DispatchQueue.main.async {
            view.isUserInteractionEnabled = true
            activity?.stopAnimating()
            activity?.removeFromSuperview()
            label?.removeFromSuperview()
            
            // Reset state
            activity = nil
            label = nil
            isShowing = false
        }
    }
}


class ActivityIndicatorView: UIView {
    static let shared = ActivityIndicatorView()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.2) // Semi-transparent background
        layer.cornerRadius = 10
        clipsToBounds = true
        
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func startLoading(in view: UIView) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            frame = view.bounds
            view.addSubview(self)
            activityIndicator.startAnimating()
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            activityIndicator.stopAnimating()
            removeFromSuperview()
        }
    }
}
