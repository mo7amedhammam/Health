//
//  TipsCategoriesDetailsVC.swift
//  Health
//
//  Created by Hamza on 26/08/2023.
//

import UIKit

class TipsCategoriesDetailsVC: UIViewController {
    
    @IBOutlet weak var LaTitle: UILabel!
    @IBOutlet weak var LaType: UILabel!
    @IBOutlet weak var LaDate: UILabel!
    @IBOutlet weak var LaDescription: UILabel!
    
    @IBOutlet weak var ViewFirst: UIView!
    @IBOutlet weak var ViewSecond: UIView!

    var selectedTipId:Int?
    var ViewModel : TipsDetailsVM?
    override func viewDidLoad() {
        super.viewDidLoad()

        let cornerRadius: CGFloat = 60.0
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: ViewFirst.bounds,
                                      byRoundingCorners: [.bottomLeft],
                                      cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        let maskLayer2 = CAShapeLayer()
        maskLayer2.path = UIBezierPath(roundedRect: ViewSecond.bounds,
                                      byRoundingCorners: [.bottomLeft],
                                      cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        ViewSecond.layer.mask = maskLayer2
        //
        ViewFirst.cornerRadius = 50
        ViewFirst.layer.maskedCorners = [.layerMinXMaxYCorner ]
   
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
                SimpleAlert.shared.showAlert(title:error.localizedDescription,message:"", viewController: self)
            }
        }
    }
    
    func updateDetails(model:TipDetailsM?){
        guard let model = model else{return}
        LaTitle.text = model.title
        LaDescription.setJustifiedRight("\(model.description ?? "")")
        LaType.text = model.tipCategoryTitle
        LaDate.text = model.date?.CangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd / MM / yyyy hh:mm a")
    }
}
