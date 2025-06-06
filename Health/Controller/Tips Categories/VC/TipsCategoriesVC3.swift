//
//  TipsCategoriesVC3.swift
//  Health
//
//  Created by Hamza on 26/08/2023.
//

import UIKit

class TipsCategoriesVC3: UIViewController {
    
    @IBOutlet weak var BtnBack: UIButton!
    @IBOutlet weak var LaTitleBare: UILabel!
    @IBOutlet weak var TVScreen: UITableView!
    let refreshControl = UIRefreshControl()
    var categoryId:Int? // to get list by categoryid
    var LaTitle : String?
    
    var ViewModel = TipsDetailsVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        LaTitleBare.text = LaTitle
        TVScreen.dataSource = self
        TVScreen.delegate   = self
        TVScreen.registerCellNib(cellClass: TipsCategories3TVCell.self)
        TVScreen.rowHeight = UITableView.automaticDimension

        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        TVScreen.addSubview(refreshControl)
        BtnBack.setImage(UIImage(resource: .backLeft).flippedIfRTL, for: .normal)
        ViewModel.skipCount = 0
        ViewModel.tipsByCategoryRes?.items?.removeAll()
        TVScreen.reloadData()
        getTipsByCategoryId()
        
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //
    //        ViewModel.skipCount = 0
    //        ViewModel.tipsByCategoryRes?.items?.removeAll()
    //        TVScreen.reloadData()
    //        getTipsByCategoryId()
    //    }
    
    
    @IBAction func BUNoti(_ sender: Any) {
    }
    
    @IBAction func BUBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension TipsCategoriesVC3 : UITableViewDataSource , UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewModel.tipsByCategoryRes?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TipsCategories3TVCell", for: indexPath) as! TipsCategories3TVCell
        let model  = ViewModel.tipsByCategoryRes?.items?[indexPath.row]
        cell.model = model
        cell.CVDrugGroups.tag = indexPath.row
        cell.CVDrugGroups.reloadData()
//        cell.CVDrugGroups.layoutIfNeeded()
        
        cell.LaTitle.text = model?.title
        cell.LaTitle.setLineSpacing(5.0)

        cell.LaDAte.text = model?.date?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd / MM / yyyy hh:mm a")
        if let img = model?.image {
            cell.ImgTipCategory.kf.setImage(with: URL(string:Constants.imagesURL + img.validateSlashs()), placeholder: UIImage(named: "defaultLogo"), options: nil, progressBlock: nil)
        }
        
//        let contentSize = cell.CVDrugGroups.collectionViewLayout.collectionViewContentSize.height
//        cell.HViewSuper.constant = (115.0 + contentSize)
        if model?.drugGroups?.count == 0 || model?.drugGroups?.count == 1 || model?.drugGroups?.count == 2 {
            cell.HViewSuper.constant = 120
        } else {
            cell.HViewSuper.constant = (120.0 + cell.calculateCollectionViewHeight())
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: TipsCategoriesDetailsVC.self) else {return}
        vc.ViewModel = ViewModel
        let model = ViewModel.tipsByCategoryRes?.items?[indexPath.row]
        vc.selectedTipId = model?.id
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 33
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let model = ViewModel.tipsByCategoryRes
        
        if indexPath.row == (model?.items?.count ?? 0)  - 1 {
            // Check if the last cell is about to be displayed
            if let totalCount = model?.totalCount, let itemsCount = model?.items?.count, itemsCount < totalCount {
                // Load the next page if there are more items to fetch
                loadNextPage(itemsCount)
            }
        }
    }
    
    func loadNextPage(_ skipcount:Int){
        ViewModel.skipCount = skipcount
        getTipsByCategoryId()
    }
    
}

extension TipsCategoriesVC3 {
    func getTipsByCategoryId(){
        Task{
            do{
                ViewModel.categoryId = categoryId
                Hud.showHud(in: self.view)
                try await ViewModel.GetTipsByCategory()
                // Handle success async operations
                Hud.dismiss(from: self.view)
                TVScreen.reloadData()
                
                if ViewModel.tipsByCategoryRes?.items?.count == 0 {
                    LoadView_NoContent(Superview: TVScreen , title: "لا يوجد محتوي", img: "noscheduals")
                } else {
                    CloseView_NoContent()
                }
                
                print("all",ViewModel.tipsByCategoryRes?.items ?? [])
            } catch {
                // Handle any errors that occur during the async operations
                print("Error: \(error)")
                Hud.dismiss(from: self.view)
                //                SimpleAlert.shared.showAlert(title:error.localizedDescription,message:"", viewController: self)
            }
        }
    }
    
    @objc func refreshData() {
        ViewModel.skipCount = 0
        ViewModel.tipsByCategoryRes?.items?.removeAll()
        TVScreen.reloadData()
        getTipsByCategoryId()
        // When the refresh operation is complete, endRefreshing() to hide the refresh control
        refreshControl.endRefreshing()
    }
    
}


class CustomCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if !(__CGSizeEqualToSize(bounds.size,self.intrinsicContentSize)){
            self.invalidateIntrinsicContentSize()
        }
    }
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}

@IBDesignable
class CardView1: UIView {

    @IBInspectable override var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.shadowRadius = newValue
            layer.masksToBounds = false
        }
    }

    @IBInspectable override var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
            layer.shadowColor = UIColor.darkGray.cgColor
        }
    }

    @IBInspectable override var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
            layer.shadowColor = UIColor.black.cgColor
            layer.masksToBounds = false
        }
    }

}
