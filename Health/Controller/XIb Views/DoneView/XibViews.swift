//
//  XibViews.swift
//  Health
//
//  Created by Hamza on 05/08/2023.
//

import UIKit

extension UIViewController {
    
    static var customView_Done = ViewDone().loadNib() as! ViewDone
    
    func Show_View_Done (SuperView : UIView , load : Bool , Stringtitle : String , imgName : String, completion: (() -> Void)? = nil ) {
        
        UIViewController.customView_Done.frame = SuperView.bounds
        
        if load == true {
            UIViewController.customView_Done.LaTitle.text = Stringtitle
            UIViewController.customView_Done.IVPhoto.image = UIImage(named: imgName)
//            UIViewController.customView_Done.BtnDone.target(forAction: completion, withSender: self)
            //
            SuperView.addSubview(UIViewController.customView_Done)
        } else {
            UIViewController.customView_Done.removeFromSuperview()
        }
    }
    
     func showView<T: UIView>(fromNib viewNib: T.Type, in viewController: UIViewController, buttonAction: (() -> Void)? = nil) -> T? {
        guard let viewDone = Bundle.main.loadNibNamed(String(describing: viewNib), owner: nil, options: nil)?.first as? T else {return nil}
         
         // Set initial alpha to 0
         viewDone.alpha = 0

               // Add the view to the viewController's view hierarchy
               viewController.view.addSubview(viewDone)
               
               // Layout and position the view within the viewController's view
               viewDone.translatesAutoresizingMaskIntoConstraints = false
               NSLayoutConstraint.activate([
                   viewDone.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
                   viewDone.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
                   viewDone.topAnchor.constraint(equalTo: viewController.view.topAnchor),
                   viewDone.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor)
               ])
               
         // Animate the view's alpha to 1 with a fade-in animation
            UIView.animate(withDuration: 0.3) {
                viewDone.alpha = 1
            }
         
         
//         // Animate the view's alpha to 1 with a fade-in animation
//           UIView.animate(withDuration: 0.3, animations: {
//               viewDone.alpha = 1
//           }) { (_) in
//               // Add a bounce effect to the view
//               let animation = CASpringAnimation(keyPath: "transform.scale")
//               animation.duration = 0.5
//               animation.fromValue = 0.7
//               animation.toValue = 1.0
//               animation.damping = 7.0
//               animation.initialVelocity = 0.5
//               viewDone.layer.add(animation, forKey: "bounce")
//           }

               return viewDone
           
       }
    
    
}
