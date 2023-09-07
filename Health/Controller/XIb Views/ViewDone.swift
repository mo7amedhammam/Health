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
            LaTitle.text = title
        }
    }
    
     var action: (()->Void)?
       @IBAction func buttonPressed(_ sender: UIButton) {
           action?()
       }

   
}

