//
//  WillExpireVC.swift
//  Sehaty
//
//  Created by Hamza on 09/10/2023.
//

import UIKit

class WillExpireVC: UIViewController {
    
    @IBOutlet weak var TVScreen: UITableView!
    @IBOutlet weak var LaTitle: UILabel!
    
    var ViewModelHome : AlmostFinishedVM?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        TVScreen.dataSource = self
        TVScreen.delegate   = self
        TVScreen.registerCellNib(cellClass: WillExpireTVCell.self)
        
    }
    
    @IBAction func BUBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}


extension WillExpireVC : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewModelHome?.responseModel?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WillExpireTVCell", for: indexPath) as! WillExpireTVCell
        cell.LaTitle.text = ViewModelHome?.responseModel?.items?[indexPath.row].drugTitle ?? ""
        cell.LaEndDate.text = ViewModelHome?.responseModel?.items?[indexPath.row].endDate?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd/MM/yyyy")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let model = ViewModelHome?.responseModel
        if indexPath.row == (model?.items?.count ?? 0)  - 1 {
            // Check if the last cell is about to be displayed
            if let totalCount = model?.totalCount, let itemsCount = model?.items?.count, itemsCount < totalCount {
                // Load the next page if there are more items to fetch
                loadNextPage(itemsCount)
            }
        }
    }
    
    func loadNextPage(_ skipcount:Int){
        ViewModelHome?.skipCount = skipcount
        getData()
    }
    
    
    func getData(){
        Task {
            do{
                Hud.showHud(in: self.view)
                try await ViewModelHome?.getHomeAlmostFinish()
                Hud.dismiss(from: self.view)
                TVScreen.reloadData()
            } catch {
                print("Error: \(error)")
                Hud.dismiss(from: self.view)
//                SimpleAlert.shared.showAlert(title:error.localizedDescription,message:"", viewController: self)
            }
        }
    }
    
    
}
