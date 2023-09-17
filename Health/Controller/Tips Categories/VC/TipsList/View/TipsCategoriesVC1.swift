//
//  TipsCategoriesVC1.swift
//  Health
//
//  Created by Hamza on 26/08/2023.
//

import UIKit

class TipsCategoriesVC1: UIViewController {
    
    @IBOutlet weak var TVScreen: UITableView!
    var ArrInt = [Int]()
    var TypeCollection = ""
    
    let ViewModel = TipsVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        TVScreen.dataSource = self
        TVScreen.delegate   = self
        TVScreen.registerCellNib(cellClass: TipsCategoriesTVCell0.self)
        TVScreen.registerCellNib(cellClass: TipsCategoriesTVCell1.self)
        
        ArrInt.append(0)
        ArrInt.append(1)
        ArrInt.append(1)
        ArrInt.append(1)

        TVScreen.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        getallTips()
        getmostviewed()
    }
}


extension TipsCategoriesVC1 : UITableViewDataSource , UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrInt.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if ArrInt[indexPath.row] == 0 {
            // cell 0
            let cell = tableView.dequeueReusableCell(withIdentifier: "TipsCategoriesTVCell0", for: indexPath) as! TipsCategoriesTVCell0
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection         = .horizontal
            layout.minimumLineSpacing      = 20
            layout.minimumInteritemSpacing = 0
            cell.CollectionTips.collectionViewLayout = layout
            cell.CollectionTips.dataSource = self
            cell.CollectionTips.delegate = self
            cell.CollectionTips.registerCell(cellClass: TipsCategoriesCVCell0.self)
            cell.CollectionTips.semanticContentAttribute = .forceRightToLeft
            TypeCollection = "0"
            cell.CollectionTips.reloadData()
            
            return cell
            
        } else {
            // cell 1
            let cell = tableView.dequeueReusableCell(withIdentifier: "TipsCategoriesTVCell1", for: indexPath) as! TipsCategoriesTVCell1
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection         = .horizontal
            layout.minimumLineSpacing      = 30
            layout.minimumInteritemSpacing = 0
            cell.CollectionCat.collectionViewLayout = layout
            cell.CollectionCat.dataSource = self
            cell.CollectionCat.delegate = self
            cell.CollectionCat.registerCell(cellClass: TipsCategoriesCVCell1.self)
            cell.CollectionCat.semanticContentAttribute = .forceRightToLeft
            // cell 0
            TypeCollection = "1"
            cell.CollectionCat.reloadData()
            
            return cell
            
        }
    }
    
}


extension TipsCategoriesVC1 : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if TypeCollection == "0" {
            // cell 0
            return 5
        } else {
            // cell 1
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if TypeCollection == "0"  {
            // cell 0
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TipsCategoriesCVCell0", for: indexPath) as! TipsCategoriesCVCell0
            return cell
        } else {
            // cell 1
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TipsCategoriesCVCell1", for: indexPath) as! TipsCategoriesCVCell1
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if TypeCollection == "0" {
            return CGSize(width: 140, height: 180)
        } else {
            return CGSize(width: 250, height: 253)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TipsCategoriesVC2") as! TipsCategoriesVC2
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
        
        
        
    }
    
}


extension TipsCategoriesVC1{
    func getmostviewed(){
        Task {
            do{
                Hud.showHud(in: self.view)
                try await ViewModel.getAllTips()
                // Handle success async operations
//                print("ViewModel.mostViewedTipsArr",ViewModel.mostViewedTipsArr)
                Hud.dismiss(from: self.view)
                print("all",ViewModel.allTipsResModel?.items)
                print("interesting",ViewModel.interestingTipsArr)
                print("newest",ViewModel.newestTipsArr)
                print("mostview",ViewModel.mostViewedTipsArr)
            }catch {
                // Handle any errors that occur during the async operations
                print("Error: \(error)")
                Hud.dismiss(from: self.view)
                SimpleAlert.shared.showAlert(title:error.localizedDescription,message:"", viewController: self)
            }
        }
    }
}
