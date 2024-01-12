//
//  TipsCategoriesDetailsVC.swift
//  Health
//
//  Created by Hamza on 26/08/2023.
//

import UIKit
import WebKit

class TipsCategoriesDetailsVC: UIViewController {
    
    @IBOutlet weak var ImgTipDetails: UIImageView!
    @IBOutlet weak var LaTitle: UILabel!
    @IBOutlet weak var LaType: UILabel!
    @IBOutlet weak var LaDate: UILabel!
//    @IBOutlet weak var CVDrugGroups: UICollectionView!
    
    @IBOutlet weak var ViewFirst: UIView!
    @IBOutlet weak var ViewSecond: UIView!

    @IBOutlet weak var ViewImage: UIView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var LaDescription: UILabel!
    
    var selectedTipId:Int?
    var ViewModel : TipsDetailsVM?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInits()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTipDetails()
    }

    @IBAction func BUBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func BUNoti(_ sender: Any) {
    }
 
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
}

extension TipsCategoriesDetailsVC {
    func getTipDetails() {
        Task{
            do{
                ViewModel?.tipId = selectedTipId
                Hud.showHud(in: self.view)
                try await ViewModel?.GetTipDetails()
                // Handle success async operations
                Hud.dismiss(from: self.view)
                updateDetails(model: ViewModel?.tipDetailsRes)
//                print("all",ViewModel?.tipDetailsRes )
            }catch {
                // Handle any errors that occur during the async operations
                print("Error: \(error)")
                Hud.dismiss(from: self.view)
//                SimpleAlert.shared.showAlert(title:error.localizedDescription,message:"", viewController: self)
            }
        }
    }
    
    func updateDetails(model:TipDetailsM?){
        guard let model = model else{return}
        if let img = model.image {
            //                let processor = SVGImgProcessor() // if receive svg image
            ImgTipDetails.kf.setImage(with: URL(string:Constants.baseURL + img.validateSlashs()), placeholder: UIImage(named: "defaultLogo"), options: nil, progressBlock: nil)
        }

        LaTitle.text = model.title
        LaTitle.setLineSpacing(10.0)
        LaTitle.textAlignment = .right

        guard let htmlString = model.description else {return}
////        webView.loadHTMLStringWithAutoDirection(htmlString)
//        let webView = WKWebView(frame: ViewWKWebview.bounds)
//        ViewWKWebview.addSubview(webView)
////        webView.loadHTMLStringWithAutoDirection(htmlString)
//        webView.loadHTMLString(htmlString, baseURL: nil)

        
        LaDescription.text = model.description?.convertHTMLToPlainText()
        LaDescription.setLineHeight(lineHeight: 2.0)

        
//    webView.loadHTMLStringWithAutoDirection(htmlString)

        
        
        LaType.text = model.tipCategoryTitle
        LaDate.text = model.date?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd / MM / yyyy hh:mm a")

    }
    
    fileprivate func setInits() {
        
        ViewSecond.cornerRadius = 50
        ViewSecond.layer.maskedCorners = [.layerMinXMaxYCorner ]
        
        ViewFirst.cornerRadius = 50
        ViewFirst.layer.maskedCorners = [.layerMinXMaxYCorner ]
  
    }
    
}







