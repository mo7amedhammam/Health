//
//  XibViews.swift
//  Health
//
//  Created by Hamza on 05/08/2023.
//

import UIKit

extension UIViewController {
    
    static var customView_Done = ViewDone().loadNib() as! ViewDone
    
    func Show_View_Done (SuperView : UIView , load : Bool , Stringtitle : String , imgName : String ) {
        
        UIViewController.customView_Done.frame = SuperView.bounds
        
        if load == true {
            UIViewController.customView_Done.LaTitle.text = Stringtitle
            UIViewController.customView_Done.IVPhoto.image = UIImage(named: imgName)
            //
            SuperView.addSubview(UIViewController.customView_Done)
        } else {
            UIViewController.customView_Done.removeFromSuperview()
        }
    }
    
    
}
