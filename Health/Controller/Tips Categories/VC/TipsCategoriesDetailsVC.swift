//
//  TipsCategoriesDetailsVC.swift
//  Health
//
//  Created by Hamza on 26/08/2023.
//

import UIKit
import WebKit

class TipsCategoriesDetailsVC: UIViewController {
    
    @IBOutlet weak var BtnBack: UIButton!
    @IBOutlet weak var ImgTipDetails: UIImageView!
    @IBOutlet weak var LaTitle: UILabel!
    @IBOutlet weak var LaType: UILabel!
    @IBOutlet weak var LaDate: UILabel!
//    @IBOutlet weak var CVDrugGroups: UICollectionView!
    
//    @IBOutlet weak var ViewFirst: UIView!
    @IBOutlet weak var ViewSecond: UIView!

    @IBOutlet weak var ViewImage: UIView!
    @IBOutlet weak var webView: WKWebView!
//    @IBOutlet weak var LaDescription: UILabel!
    
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
            ImgTipDetails.kf.setImage(with: URL(string:Constants.imagesURL + img.validateSlashs()), placeholder: UIImage(named: "defaultLogo"), options: nil, progressBlock: nil)
        }

        LaTitle.text = model.title
        LaTitle.setLineSpacing(10.0)
        LaTitle.textAlignment = .right
        LaType.text = model.tipCategoryTitle
        LaDate.text = model.date?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd / MM / yyyy hh:mm a")

        guard let htmlString = model.description else {return}
////        webView.loadHTMLStringWithAutoDirection(htmlString)
//        let webView = WKWebView(frame: ViewWKWebview.bounds)
//        ViewWKWebview.addSubview(webView)
////        webView.loadHTMLStringWithAutoDirection(htmlString)
//        LaDescription.text = model.description?.convertHTMLToPlainText()
//        LaDescription.setLineHeight(lineHeight: 2.0)
//    webView.loadHTMLStringWithAutoDirection(htmlString)
        
        // webView.loadHTMLString(htmlString, baseURL: nil)
        
//        let headString = "<head><meta name='viewport' content='width=device-width, initial-scale=0.5, maximum-scale=0.5, minimum-scale=0.5, user-scalable=no'></head>"
//        webView.loadHTMLString(headString + htmlString , baseURL: nil)
        
        
        let headString = "<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></head>"
        let htmlString2 = "<html><body dir='rtl'>\(htmlString)</body></html>"
        webView.loadHTMLString(headString + htmlString2, baseURL: nil)
        
//        let fontSize = 50 // Adjust the font size as needed

//        let headString = "<head><meta name='viewport' content='width=device-width, initial-scale=0.5, maximum-scale=0.5, minimum-scale=0.5, user-scalable=no'><style>body { font-size: \(fontSize)px; }</style></head>"
//
//        let htmlStringWithCustomFontSize = "<html><body dir='rtl'>\(htmlString)</body></html>"
//        let finalHtmlString = headString + htmlStringWithCustomFontSize
//
//        webView.loadHTMLString(finalHtmlString, baseURL: nil)
       
    }
    
    fileprivate func setInits() {
        BtnBack.setImage(UIImage(resource: .backLeft).flippedIfRTL, for: .normal)
        LaDate.reverselocalizedview()
        ViewSecond.cornerRadius = 20
        ViewSecond.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner ]
        
//        ViewFirst.cornerRadius = 50
//        ViewFirst.layer.maskedCorners = [.layerMinXMaxYCorner ]
  
    }
    
}







