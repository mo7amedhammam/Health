//
//  ControllViews.swift
//  Sehaty
//
//  Created by Hamza on 17/10/2023.
//

import Foundation
import UIKit

extension UIViewController {
    
    static var customView_NoContent    = ViewNoData ().loadNib() as! ViewNoData
    
    
    func LoadView_NoContent (Superview : UIView , title : String , img : String ) {
        
        UIViewController.customView_NoContent = ViewNoData().loadNib() as! ViewNoData
        UIViewController.customView_NoContent.frame = Superview.bounds
                
        UIViewController.customView_NoContent.LaTitle.text = title
        UIViewController.customView_NoContent.IVPhoto.image = UIImage(named: img)
        Superview.addSubview(UIViewController.customView_NoContent)
    }
    
    func CloseView_NoContent () {
        
        UIViewController.customView_NoContent.removeFromSuperview()
    }
    
    
    
}
