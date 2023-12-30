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
//    @IBOutlet weak var webView: WKWebView!

    @IBOutlet weak var ViewWKWebview: UIView!
    
    
    var selectedTipId:Int?
    var ViewModel : TipsDetailsVM?
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.webView.scrollView.delegate = self
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
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
             scrollView.pinchGestureRecognizer?.isEnabled = true
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
//        webView.loadHTMLStringWithAutoDirection(htmlString)
        
        let webView = WKWebView(frame: ViewWKWebview.bounds)
//        webView.navigationDelegate = self
        ViewWKWebview.addSubview(webView)
        webView.loadHTMLStringWithAutoDirection(htmlString)

//        webView.loadHTMLString(htmlString, baseURL: nil)


        print("model.description : \(model.description)")
        LaType.text = model.tipCategoryTitle
        LaDate.text = model.date?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd / MM / yyyy hh:mm a")
//        CVDrugGroups.reloadData()
    }
    
    fileprivate func setInits() {
        
//        let cornerRadius: CGFloat = 60.0
//        let maskLayer = CAShapeLayer()
//        maskLayer.path = UIBezierPath(roundedRect: ViewFirst.bounds,
//                                      byRoundingCorners: [.bottomLeft],
//                                      cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
//        let maskLayer2 = CAShapeLayer()
//        maskLayer2.path = UIBezierPath(roundedRect: ViewSecond.bounds,
//                                      byRoundingCorners: [.bottomLeft],
//                                      cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
//        ViewSecond.layer.mask = maskLayer2
        //
        
        ViewSecond.cornerRadius = 50
        ViewSecond.layer.maskedCorners = [.layerMinXMaxYCorner ]
        
        
        ViewFirst.cornerRadius = 50
        ViewFirst.layer.maskedCorners = [.layerMinXMaxYCorner ]
        
        // drup groups collection tags .
//        CVDrugGroups.dataSource = self
//        CVDrugGroups.delegate = self
//        CVDrugGroups.registerCell(cellClass: TipDetailsDrugGroup.self)
//        CVDrugGroups.transform = CGAffineTransform(scaleX: -1, y: 1) //first tip mirror effect for x -> second in cell
        
    }
    
}
//
//extension TipsCategoriesDetailsVC:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return ViewModel?.tipDetailsRes?.drugGroups?.count ?? 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TipDetailsDrugGroup", for: indexPath) as! TipDetailsDrugGroup
//        let model = ViewModel?.tipDetailsRes?.drugGroups?[indexPath.row]
//        cell.LaDrugTitle.font = UIFont(name: "LamaSans-Medium", size: 15)
//        cell.LaDrugTitle.text = model?.title
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        // Calculate and return the size of the cell based on your content
//        return CGSize(width: collectionView.bounds.width, height: 30)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10.0 // Adjust the spacing between cells as needed
//    }
//}








