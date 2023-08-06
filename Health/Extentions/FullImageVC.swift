//
//  FullImageVC.swift
//  Flash Card
//
//  Created by mac on 05/10/2021.
//

import UIKit
//import SDWebImage
import Kingfisher



class FullImageVC: UIViewController {

    
    var imageUrl = ""
    var imageToShow: UIImage?
    
    @IBOutlet weak var IVFuul: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let url = imageUrl {
////            imageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named:   "imagePlaceholder") )
//            Helper.SetImage(EndPoint: url, image: imageView, name: "book", status: 1)
//        } else {
//            if let image = imageToShow {
//                imageView.image = image
//            }
//        }
        
        print("imageUrl : \(imageUrl)")
        
        if imageUrl == "" {
            IVFuul.image = #imageLiteral(resourceName: "6")
        } else {
            
            Helper.SetImage(EndPoint: imageUrl , image: IVFuul, name: "book", status: 1)
        }
        

        
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
       return self.IVFuul
    }
    
    
    
    @IBAction func BUBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
  

}

// from url

//let iVC = FullImageVC()
//iVC.imageUrl = url
//self.navigationController?.pushViewController(iVC, animated: true)


//     from local
//if let image = imageToShow.image {
//  let iVC = FullImageVC()
//  iVC.imageToShow = image
//  self.navigationController?.pushViewController(iVC, animated: true)
//}
