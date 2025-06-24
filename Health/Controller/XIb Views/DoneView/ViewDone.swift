//
//  ViewDone.swift
//  Health
//
//  Created by Hamza on 05/08/2023.
//

import UIKit

class ViewDone: UIView {
    
    @IBOutlet weak var IVPhoto: UIImageView!
    
    @IBOutlet weak var LaTitle: UILabel!
    
    @IBOutlet weak var LaSubtitle1: UILabel!
    @IBOutlet weak var LaSubtitle2: UILabel!
    
    @IBOutlet weak var BtnDone: UIButton!
    var imgStr:String?{
        didSet{
            if let imageName = imgStr {
                IVPhoto.image = UIImage(named: imageName)
            }
        }
    }
    var title:String?{
        didSet{
            LaTitle.text = title?.localized
        }
    }
    
    var subtitle1:String?{
        didSet{
            LaSubtitle1.text = subtitle1?.localized
        }
    }
    var subtitle2:String?{
        didSet{
            LaSubtitle2.text = subtitle2?.localized
        }
    }
  
    var ButtonTitle:String?{
        didSet{
            BtnDone.setTitle(ButtonTitle?.localized, for: .normal)
            applyHorizontalGradient(to: BtnDone)
        }
    }
    var action: (()->Void)?
    @IBAction func buttonPressed(_ sender: UIButton) {
        action?()
    }
    
    
}

