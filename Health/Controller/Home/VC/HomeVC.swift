//
//  HomeVC.swift
//  Health
//
//  Created by Hamza on 01/10/2023.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var LaName: UILabel!
    @IBOutlet weak var ImgUser: UIImageView!
    @IBOutlet weak var TVScreen: UITableView!
    let refreshControl = UIRefreshControl()
    let ViewModelMeasurements = MyMeasurementsStatsVM()

    let ViewModel = TipsVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SetUserHeader()
        TVScreen.dataSource = self
        TVScreen.delegate   = self
        TVScreen.registerCellNib(cellClass: HomeTVCell0.self)
        TVScreen.registerCellNib(cellClass: HomeTVCell1.self)
//        TVScreen.reloadData()
        // Configure the refresh control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
           
           // Add the refresh control to the table view
        TVScreen.addSubview(refreshControl)
        getTipsCategories()
    }
}

extension HomeVC : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVCell0", for: indexPath) as! HomeTVCell0
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVCell1", for: indexPath) as! HomeTVCell1
            cell.nav =  self.navigationController
            cell.DataSourseDeledate()
            cell.indexx = indexPath.row
            //
            if indexPath.row == 1 {
                cell.ViewModelMeasurements = ViewModelMeasurements
                cell.HViewCell.constant = 400
                cell.BtnMore.isHidden   = true
                cell.LaTitle.text = "قياساتك الأخيرة"
            } else if indexPath.row == 2 {
                cell.HViewCell.constant = 220
                cell.BtnMore.isHidden   = false
                cell.LaTitle.text = "الأدوية التي قاربة على الإنتهاء"
            } else if indexPath.row == 3 {
                cell.ViewModel = ViewModel
                cell.HViewCell.constant = 320
                cell.BtnMore.isHidden   = false
                cell.LaTitle.text = "نصائح حديثة"
            } else  {
                cell.ViewModel = ViewModel
                cell.HViewCell.constant = 320
                cell.BtnMore.isHidden   = false
                cell.LaTitle.text = "النصائح الأكثر مشاهدة"
            }
            
            return cell
        }
    }
    
}

//--Functions--
extension HomeVC{
    func SetUserHeader(){
        LaName.text = "\(Helper.getUser()?.name ?? "")"
//        if let img = Helper.getUser()?.image {
//            //                let processor = SVGImgProcessor() // if receive svg image
//            ImgUser.kf.setImage(with: URL(string:Constants.baseURL + img.validateSlashs()), placeholder: UIImage(named: "person"), options: nil, progressBlock: nil)
//        }

    }
    func getTipsCategories(){
        Task {
            do{
                Hud.showHud(in: self.view)
                ViewModel.newestTipsArr = try await ViewModel.GetNewestTips()
                ViewModel.mostViewedTipsArr = try await ViewModel.GetMostViewedTips()
                ViewModelMeasurements.ArrStats = try await ViewModelMeasurements.asyncGetMeasurementsStats()
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
