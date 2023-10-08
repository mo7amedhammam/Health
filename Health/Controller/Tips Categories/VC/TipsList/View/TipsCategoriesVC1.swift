//
//  TipsCategoriesVC1.swift
//  Health
//
//  Created by Hamza on 26/08/2023.
//

import UIKit

class TipsCategoriesVC1: UIViewController {
    
    @IBOutlet weak var TVScreen: UITableView!
    let refreshControl = UIRefreshControl()
    
    let ViewModel = TipsVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        TVScreen.dataSource = self
        TVScreen.delegate   = self
        TVScreen.registerCellNib(cellClass: TipsCategoriesTVCell0.self)
        TVScreen.registerCellNib(cellClass: TipsCategoriesTVCell1.self)
        // Configure the refresh control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
           
           // Add the refresh control to the table view
        TVScreen.addSubview(refreshControl)
        getTipsCategories()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.global().asyncAfter(deadline: .now()+1, execute: {[weak self] in
            guard let self = self else{return}
            if ViewModel.allTipsResModel?.items == nil || ViewModel.allTipsResModel?.items == [] && Hud.isShowing == false {
                    getTipsCategories()
            }
        })
    }
    
    @IBAction func BackBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
            cell.nav = self.navigationController
            cell.ViewModel = ViewModel
            cell.LaCategoryTitle.text = "تصنيفات النصائح"
            return cell
            
        case 1: // newest
            let cell = tableView.dequeueReusableCell(withIdentifier: "TipsCategoriesTVCell1", for: indexPath) as! TipsCategoriesTVCell1
            cell.nav = self.navigationController
            cell.tipcategirytype = .Newest
            cell.LaCategoryTitle.text = "نصائح حديثة"
            if let model = ViewModel.newestTipsArr {
                cell.dataArray = model
            }
            return cell
            
        case 2: // newest
            let cell = tableView.dequeueReusableCell(withIdentifier: "TipsCategoriesTVCell1", for: indexPath) as! TipsCategoriesTVCell1
            cell.nav = self.navigationController
            cell.tipcategirytype = .Interesting
            cell.LaCategoryTitle.text = "نصائح تهمك"
            if let model = ViewModel.interestingTipsArr {
                cell.dataArray = model
            }
            return cell
            
        default: // most viewed
            let cell = tableView.dequeueReusableCell(withIdentifier: "TipsCategoriesTVCell1", for: indexPath) as! TipsCategoriesTVCell1
            cell.nav = self.navigationController
            cell.tipcategirytype = .MostViewed
            cell.LaCategoryTitle.text = "النصائح الأكثر مشاهدة"
            if let model = ViewModel.mostViewedTipsArr {
                cell.dataArray = model
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: TipsCategoriesVC3.self) else {return}
        vc.hidesBottomBarWhenPushed = true
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
    
    @objc func refreshData() {
        ViewModel.skipCount = 0
        // Place your refresh logic here, for example, fetch new data from your data source
        getTipsCategories()

        // When the refresh operation is complete, endRefreshing() to hide the refresh control
        refreshControl.endRefreshing()
    }
}

