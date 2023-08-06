//
//  RecieveImageVC.swift
//  Flash Card
//
//  Created by mac on 11/04/2022.
//

import UIKit

class RecieveImageVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var IVChat: UIImageView!
    var img : UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    var UrlString : String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: UrlString)
        IVChat.kf.indicatorType = .activity
        IVChat.kf.setImage(with: url)


        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        scrollView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return IVChat
    }
    
    @IBAction func BtnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
