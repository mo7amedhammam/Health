//
//  TipsCategoriesVC2.swift
//  Health
//
//  Created by Hamza on 26/08/2023.
//

import UIKit

enum enumTipsCategories {
    case All
    case Newest
    case Interesting
    case MostViewed
}
class TipsCategoriesVC2: UIViewController {
    @IBOutlet weak var LaTitleBare: UILabel!
    @IBOutlet weak var CollectionScreen: UICollectionView!
    let refreshControl = UIRefreshControl()
    
    var ViewModel : TipsVM?
    var dataArray : [TipsNewestM]?
    var tipcategirytype:enumTipsCategories = .All
    var LaTitle:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setInits()
    }
    
    @IBAction func BUNoti(_ sender: Any) {
    }
    
    @IBAction func BUBack(_ sender: Any) {
//        self.dismiss(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
}

extension TipsCategoriesVC2 : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch tipcategirytype{
        case .All:
            return ViewModel?.allTipsResModel?.items?.count ?? 0
        case .Newest:
            return dataArray?.count ?? 0
        case .Interesting:
            return dataArray?.count ?? 0
        case .MostViewed:
            return dataArray?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TipsCategories2CVCell", for: indexPath) as! TipsCategories2CVCell
        switch tipcategirytype{
        case .All:
            let model = ViewModel?.allTipsResModel?.items?[indexPath.row]
            cell.model = secondVCTipM.init(image: model?.image, title: model?.title,id: model?.id, subjectsCount: model?.subjectsCount)
        case .Newest:
            let model = dataArray?[indexPath.row]
            cell.model = secondVCTipM.init(image: model?.image, title: model?.title,date: model?.date,subjectsCount: 0 )
        case .Interesting:
            let model = dataArray?[indexPath.row]
            cell.model = secondVCTipM.init(image: model?.image, title: model?.title,date: model?.date,subjectsCount: 0 )

        case .MostViewed:
            let model = dataArray?[indexPath.row]
            cell.model = secondVCTipM.init(image: model?.image, title: model?.title,date: model?.date, subjectsCount: 0)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width / 2) - 10  , height: 253)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "TipsCategoriesVC3") as! TipsCategoriesVC3

        switch tipcategirytype {
        case .All:
            guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: TipsCategoriesVC3.self) else{return}
                    self.navigationController?.pushViewController(vc, animated: true)
            guard let model = ViewModel?.allTipsResModel?.items?[indexPath.row] else {return}
            vc.categoryId = model.id
            vc.LaTitle = model.title
        case .Newest:
            guard let model = dataArray?[indexPath.row] else {return}
            PresentDetails(forId: model.id ?? 0)
        case .Interesting:
            guard let model = dataArray?[indexPath.row] else {return}
            PresentDetails(forId: model.id ?? 0)
        case .MostViewed:
            guard let model = dataArray?[indexPath.row] else {return}
            PresentDetails(forId: model.id ?? 0)

        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let model = ViewModel?.allTipsResModel
        if indexPath.row == (model?.items?.count ?? 0)  - 1 {
            // Check if the last cell is about to be displayed
            if let totalCount = model?.totalCount, let itemsCount = model?.items?.count, itemsCount < totalCount {
                // Load the next page if there are more items to fetch
                loadNextPage(itemsCount)
            }
        }
    }
    
    func loadNextPage(_ skipcount:Int){
        ViewModel?.skipCount = skipcount
        getHomeTips()
    }
}

// -- functions --
extension TipsCategoriesVC2{
    fileprivate func setInits() {
        // Do any additional setup after loading the view.
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection         = .vertical
        layout.minimumLineSpacing      = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10) // Adjust the insets as needed
        CollectionScreen.collectionViewLayout = layout
        CollectionScreen.dataSource = self
        CollectionScreen.delegate = self
        CollectionScreen.registerCell(cellClass: TipsCategories2CVCell.self)
        CollectionScreen.transform = CGAffineTransform(scaleX: -1, y: 1) //first tip mirror effect for x -> second in cell
        
        LaTitleBare.text = LaTitle

        // Configure the refresh control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)

           // Add the refresh control to the collection view
        CollectionScreen.addSubview(refreshControl)
           
           // Load your initial data here (e.g., fetchData())
           refreshData()

    }
    
    
    func getHomeTips(){
        Task {
            do{
                Hud.showHud(in: self.view)
                try await ViewModel?.getHomeTips()
                // Handle success async operations
                Hud.dismiss(from: self.view)
                CollectionScreen.reloadData()

            }catch {
                // Handle any errors that occur during the async operations
                print("Error: \(error)")
                Hud.dismiss(from: self.view)
                SimpleAlert.shared.showAlert(title:error.localizedDescription,message:"", viewController: self)
            }
        }
    }
    
    @objc func refreshData() {
        ViewModel?.skipCount = 0
        // Place your refresh logic here, for example, fetch new data from your data source
        getHomeTips()

        // When the refresh operation is complete, endRefreshing() to hide the refresh control
        refreshControl.endRefreshing()
    }

    func PresentDetails(forId selectedId:Int){
        guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: TipsCategoriesDetailsVC.self) else{return}
        vc.ViewModel = TipsDetailsVM()
        vc.selectedTipId = selectedId
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true)
    }
}
