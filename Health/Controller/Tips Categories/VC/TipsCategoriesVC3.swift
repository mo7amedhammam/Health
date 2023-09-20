//
//  TipsCategoriesVC3.swift
//  Health
//
//  Created by Hamza on 26/08/2023.
//

import UIKit

class TipsCategoriesVC3: UIViewController {
    
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
        
        // Configure the refresh control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        // Add the refresh control to the collection view
        TVScreen.addSubview(refreshControl)
        
        // Load your initial data here (e.g., fetchData())
        refreshData()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTipsByCategoryId()
    }
    
    
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
        let model = ViewModel.tipsByCategoryRes?.items?[indexPath.row]
        cell.model = model
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

                print("all",ViewModel.tipsByCategoryRes?.items ?? [])
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
        getTipsByCategoryId()

        // When the refresh operation is complete, endRefreshing() to hide the refresh control
        refreshControl.endRefreshing()
    }

}
