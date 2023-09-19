//
//  TipsCategoriesVC1.swift
//  Health
//
//  Created by Hamza on 26/08/2023.
//

import UIKit

class TipsCategoriesVC1: UIViewController {
    
    @IBOutlet weak var TVScreen: UITableView!
    
    let ViewModel = TipsVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        TVScreen.dataSource = self
        TVScreen.delegate   = self
        TVScreen.registerCellNib(cellClass: TipsCategoriesTVCell0.self)
        TVScreen.registerCellNib(cellClass: TipsCategoriesTVCell1.self)
//        getTipsCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        getallTips()
        getTipsCategories()
    }
}


extension TipsCategoriesVC1 : UITableViewDataSource , UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row{
        case 0: // all home -- pagination
            let cell = tableView.dequeueReusableCell(withIdentifier: "TipsCategoriesTVCell0", for: indexPath) as! TipsCategoriesTVCell0
            cell.ViewModel = ViewModel
            cell.nav = self.navigationController
            cell.LaCategoryTitle.text = "تصنيفات النصائح"
            return cell
            
        case 1: // newest
            let cell = tableView.dequeueReusableCell(withIdentifier: "TipsCategoriesTVCell1", for: indexPath) as! TipsCategoriesTVCell1
            cell.nav = self.navigationController
            cell.tipcategirytype = .Newest
//            cell.LaCategoryTitle.text = "نصائح حديثة"
//            cell.moreaction = { [weak self] in
//                guard let self = self else{return}
//                guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: TipsCategoriesVC2.self) else {return}
//                vc.ViewModel = ViewModel
//                vc.tipcategirytype = .Newest
//                self.navigationController?.pushViewController(vc, animated: true)
//            }

            if let model = ViewModel.newestTipsArr {
                cell.dataArray = model
            }
            return cell
            
        case 2: // newest
            let cell = tableView.dequeueReusableCell(withIdentifier: "TipsCategoriesTVCell1", for: indexPath) as! TipsCategoriesTVCell1
            cell.nav = self.navigationController
            cell.tipcategirytype = .Interesting

//            cell.LaCategoryTitle.text = "نصائح تهمك"
//            cell.moreaction = { [weak self] in
//                guard let self = self else{return}
//                guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: TipsCategoriesVC2.self) else {return}
//                vc.ViewModel = ViewModel
//                vc.tipcategirytype = .Interesting
//                self.navigationController?.pushViewController(vc, animated: true)
//                
//            }
            if let model = ViewModel.interestingTipsArr {
                cell.dataArray = model
            }
            return cell
            
        default: // most viewed
            let cell = tableView.dequeueReusableCell(withIdentifier: "TipsCategoriesTVCell1", for: indexPath) as! TipsCategoriesTVCell1
            cell.nav = self.navigationController
            cell.tipcategirytype = .MostViewed

//            cell.LaCategoryTitle.text = "النصائح الأكثر مشاهدة"
//            cell.moreaction = { [weak self] in
//                guard let self = self else{return}
//                guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: TipsCategoriesVC2.self) else {return}
//                vc.ViewModel = ViewModel
//                vc.tipcategirytype = .MostViewed
//                self.navigationController?.pushViewController(vc, animated: true)
//            }

            if let model = ViewModel.mostViewedTipsArr {
                cell.dataArray = model
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TipsCategoriesVC3") as! TipsCategoriesVC3
        switch indexPath.row {
        case 0:
            vc.categoryId = ViewModel.allTipsResModel?.items?[indexPath.row].id
        case 1:
            vc.categoryId = ViewModel.newestTipsArr?[indexPath.row].id
        case 2:
            vc.categoryId = ViewModel.interestingTipsArr?[indexPath.row].id
        default:
            vc.categoryId = ViewModel.mostViewedTipsArr?[indexPath.row].id
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

//MARK: -- functions --
extension TipsCategoriesVC1{
    func getTipsCategories(){
        Task {
            do{
                Hud.showHud(in: self.view)
                try await ViewModel.getAllTips()
                // Handle success async operations
                Hud.dismiss(from: self.view)
                TVScreen.reloadData()

                print("all",ViewModel.allTipsResModel?.items ?? [])
                print("interesting",ViewModel.interestingTipsArr ?? [])
                print("newest",ViewModel.newestTipsArr ?? [])
                print("mostview",ViewModel.mostViewedTipsArr ?? [])
            }catch {
                // Handle any errors that occur during the async operations
                print("Error: \(error)")
                Hud.dismiss(from: self.view)
                SimpleAlert.shared.showAlert(title:error.localizedDescription,message:"", viewController: self)
            }
        }
    }
}
