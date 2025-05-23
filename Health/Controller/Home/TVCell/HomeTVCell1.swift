//
//  HomeTVCell1.swift
//  Health
//
//  Created by Hamza on 01/10/2023.
//

import UIKit

class HomeTVCell1: UITableViewCell {

    @IBOutlet weak var HViewCell: NSLayoutConstraint!
    @IBOutlet weak var LaTitle: UILabel!
    @IBOutlet weak var BtnMore: UIButton!
    @IBOutlet weak var CollectionHome: UICollectionView!
    var TVScreen: UITableView?
    var indexx = 0
    var nav : UINavigationController?
    var ViewModelHome : AlmostFinishedVM?
    var ViewModelMeasurements : MyMeasurementsStatsVM?
//    {
//        didSet {
//            scrolltoFirst()
////            CollectionHome.reloadData()
//        }
//    }
    var ViewModel : TipsVM?
    var Num = 0
    let layout = UICollectionViewFlowLayout()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
            DataSourseDeledate()
            setupui()
    }
    override func layoutSubviews() {
    // handle RTL/LTr
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
        
    func setupui(){
        LaTitle.localized(string: "home_lastMes")
//        CollectionHome.semanticContentAttribute = Helper.shared.getLanguage() == "ar" ? .forceRightToLeft : .forceLeftToRight
    }
    
    func scrolltoFirst() {
        if CollectionHome.numberOfSections > 0 && CollectionHome.numberOfItems(inSection: 0) > 0 {
            let firstIndexPath = IndexPath(item: 0, section: 0)
            CollectionHome.scrollToItem(at: firstIndexPath, at: .centeredHorizontally, animated: true)
        }
    }
    @IBAction func BUMore(_ sender: Any) {
//            vc.dataArray = dataArray

            switch indexx {
            case 1:
                print("قياساتك الاخيره")
            case 2:
                print("الادزيه التى قاربت على الانتهاء")
                guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: WillExpireVC.self) else {return}
                if let model = ViewModelHome {
                    vc.ViewModelHome = model
                }
                vc.hidesBottomBarWhenPushed = true
                nav?.pushViewController(vc, animated: true)
                

            case 3:
                guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: TipsCategoriesVC2.self) else {return}
                vc.LaTitle = "نصائح حديثة"
                if let model = ViewModel?.newestTipsArr {
                    vc.tipcategirytype = .Newest
                    vc.dataArray = model
                }
                vc.hidesBottomBarWhenPushed = true
                nav?.pushViewController(vc, animated: true)

            default:
                guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: TipsCategoriesVC2.self) else {return}
                vc.LaTitle = "النصائح الأكثر مشاهدة"
                if let model = ViewModel?.mostViewedTipsArr {
                    vc.tipcategirytype = .MostViewed
                    vc.dataArray = model
                }
                vc.hidesBottomBarWhenPushed = true
                nav?.pushViewController(vc, animated: true)

            }
        
    }
    
    func DataSourseDeledate () {
             
//        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing      = 10
        layout.minimumInteritemSpacing = 0
        CollectionHome.collectionViewLayout =  layout
        CollectionHome.dataSource = self
        CollectionHome.delegate   = self
        CollectionHome.registerCell(cellClass: HomeCVCell1.self)
        CollectionHome.registerCell(cellClass: HomeCVCell2.self)
        CollectionHome.registerCell(cellClass: HomeCVCell3.self)
        CollectionHome.registerCell(cellClass: TipsCategoriesCVCell1.self)
//        CollectionHome.transform = CGAffineTransform(scaleX: -1, y: 1) //first tip mirror effect for x -> second in cell
//        CollectionHome.reloadData()

    }
    
}


extension HomeTVCell1 : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if indexx == 1 {
            return Num
//            return ViewModelMeasurements?.ArrStats?.count ?? 0
        } else if indexx == 2 {
            return ViewModelHome?.responseModel?.items?.count ?? 0
        } else if indexx == 3 {
            return ViewModel?.newestTipsArr?.count ?? 0
        } else {
            return ViewModel?.mostViewedTipsArr?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexx == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVCell1", for: indexPath) as! HomeCVCell1
            collectionView.isScrollEnabled = false
            guard let model = ViewModelMeasurements?.ArrStats?[indexPath.row] else { return cell }
//            if let model = ViewModelMeasurements?.ArrStats?[indexPath.row]{
                cell.model = model
//            }
            
            return cell
        } else if indexx == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVCell2", for: indexPath) as! HomeCVCell2
            collectionView.isScrollEnabled = true
            if let model = ViewModelHome?.responseModel?.items?[indexPath.row]{
                cell.model = model
            }
            print("id almost finished : \(ViewModelHome?.responseModel?.items?[indexPath.row].id)")

            return cell
        } else if indexx == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TipsCategoriesCVCell1", for: indexPath) as! TipsCategoriesCVCell1
            collectionView.isScrollEnabled = true
            if let model = ViewModel?.newestTipsArr?[indexPath.row] {
                cell.model = model
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TipsCategoriesCVCell1", for: indexPath) as! TipsCategoriesCVCell1
            collectionView.isScrollEnabled = true
            if let model = ViewModel?.mostViewedTipsArr?[indexPath.row] {
                cell.model = model
            }

            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexx == 1 {
            guard let SelectedModel = ViewModelMeasurements?.ArrStats?[indexPath.row] else{return}
            ShowMeasurementDetailFor(SelectedModel: SelectedModel , index : indexPath.row)
        } else if indexx == 2 {
            
        } else if indexx == 3 {
            let SelectedId = ViewModel?.newestTipsArr?[indexPath.row].id ?? 0
            self.ShowDetailsFor(Id: SelectedId)
        } else {
            let SelectedId = ViewModel?.mostViewedTipsArr?[indexPath.row].id ?? 0
            self.ShowDetailsFor(Id: SelectedId)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexx == 1 {
            if ViewModelMeasurements?.ArrStats?.count ?? 0 <= 3 {
                return CGSize(width: ((collectionView.frame.width - 30 )/3) , height: 185)
            } else {
                return CGSize(width: ((collectionView.frame.width - 20 )/3) , height: 185)
            }
        } else if indexx == 2 {
            return CGSize(width: 280, height: 150)
        } else {
            return CGSize(width: 250, height: 250)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexx == 2{
            let model = ViewModelHome?.responseModel
            if indexPath.row == (model?.items?.count ?? 0)  - 1 {
                // Check if the last cell is about to be displayed
                if let totalCount = model?.totalCount, let itemsCount = model?.items?.count, itemsCount < totalCount {
                    // Load the next page if there are more items to fetch
                    loadNextPage(itemsCount)
                }
            }
        }
    }
    
    func loadNextPage(_ skipcount:Int){
        ViewModelHome?.skipCount = skipcount
        Task {
            do{
                Hud.showHud(in: self)
                try await ViewModelHome?.getHomeAlmostFinish()
                Hud.dismiss(from: self)
                CollectionHome.reloadData()
            } catch {
                // Handle any errors that occur during the async operations
                print("Error: \(error)")
                Hud.dismiss(from: self)
//                SimpleAlert.shared.showAlert(title:error.localizedDescription,message:"", viewController: self)
            }
        }

    }

    
}

extension HomeTVCell1{
    
     func ShowDetailsFor(Id:Int){
        guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: TipsCategoriesDetailsVC.self) else {return}
        vc.selectedTipId = Id
        vc.ViewModel = TipsDetailsVM()
        vc.modalPresentationStyle = .fullScreen
        nav?.present(vc, animated: true)

    }
    
    func ShowMeasurementDetailFor(SelectedModel:ModelMyMeasurementsStats , index : Int){
        guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: MeasureDetailsVC.self) else{return}
        vc.ViewModel = ViewModelMeasurements ?? MyMeasurementsStatsVM()
         let model = SelectedModel
//            print("selectedModel",model)
            vc.id  =  model.medicalMeasurementID ?? 0
            vc.num = model.measurementsCount ?? 0
            vc.imgMeasurement = model.image ?? ""
            vc.TitleMeasurement = model.title ?? ""
//            vc.formatValue = model.formatValue ?? ""
            vc.formatRegex = model.regExpression ?? ""
            vc.formatHintMessage = model.normalRangValue ?? ""
        vc.TitleMeasurement = model.title ?? ""
        vc.TitleMeasurement = model.title ?? ""
        Shared.shared.MeasurementId = model.medicalMeasurementID ?? 0

        
//        print("formatValue : \( ViewModel.ArrStats![indexPath.row].formatValue!)")
        vc.hidesBottomBarWhenPushed = true
        nav?.pushViewController(vc, animated: true)
    }
}
