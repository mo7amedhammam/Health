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
    let ViewModelHome = AlmostFinishedVM()
    let ViewModelProfile = ProfileVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SetUserHeader()
        TVScreen.dataSource = self
        TVScreen.delegate   = self
        TVScreen.registerCellNib(cellClass: HomeTVCell0.self)
        TVScreen.registerCellNib(cellClass: HomeTVCell1.self)
        TVScreen.registerCellNib(cellClass: EmptyTVCell.self)
        // Configure the refresh control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
           // Add the refresh control to the table view
        TVScreen.addSubview(refreshControl)
//        getTipsCategories()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
//        if Shared.shared.IsMeasurementAdded == false {
//        } else {
//            if let arrStat = ViewModelMeasurements.ArrStats {
//                refreshData()
//                Shared.shared.IsMeasurementAdded = false
//            } else {
//                // Handle the case where arrStat is nil
//            }
//        }
        
        getTipsCategories()
        GetMyProfile()
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
            
            if indexPath.row == 1 {
                                
                if ViewModelMeasurements.ArrStats?.count == 0  {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyTVCell", for: indexPath) as! EmptyTVCell
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVCell1", for: indexPath) as! HomeTVCell1
                    cell.nav =  self.navigationController
                    cell.layout.scrollDirection   = .vertical
//                    cell.DataSourseDeledate()
                    if ViewModelMeasurements.ArrStats?.count ?? 0 <= 3 {
                        cell.HViewCell.constant = 200
                    } else {
                        cell.HViewCell.constant = 380
                    }
                    cell.indexx = indexPath.row
                    
                    if ViewModelMeasurements.ArrStats?.count ?? 0 >= 6 {
                        cell.Num = 6
                    } else {
                        cell.Num = ViewModelMeasurements.ArrStats?.count ?? 0
                    }
                    cell.ViewModelMeasurements = ViewModelMeasurements
                    cell.CollectionHome.reloadData()
                    
                    cell.BtnMore.isHidden   = true
                    cell.LaTitle.text = "قياساتك الأخيرة"
                    return cell
                }

            } else if indexPath.row == 2 {
                
                if ViewModelHome.responseModel?.items?.count == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyTVCell", for: indexPath) as! EmptyTVCell
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVCell1", for: indexPath) as! HomeTVCell1
                    cell.nav =  self.navigationController
    //                cell.DataSourseDeledate()
                    cell.layout.scrollDirection   = .horizontal

                    cell.HViewCell.constant = 220
                    cell.indexx = indexPath.row
                    cell.ViewModelHome = ViewModelHome
                    cell.CollectionHome.reloadData()
                    
                    cell.BtnMore.isHidden   = true
                    cell.LaTitle.text = "الأدوية التي قاربت على الإنتهاء"
                    return cell
                }

            } else if indexPath.row == 3 {
                
                if ViewModel.newestTipsArr?.count == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyTVCell", for: indexPath) as! EmptyTVCell
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVCell1", for: indexPath) as! HomeTVCell1
                    cell.nav =  self.navigationController
                    cell.layout.scrollDirection   = .horizontal
//                    cell.DataSourseDeledate()
                    cell.HViewCell.constant = 320
                    cell.indexx = indexPath.row
                    cell.ViewModel = ViewModel
                    cell.CollectionHome.reloadData()
                    
                    cell.BtnMore.isHidden   = false
                    cell.LaTitle.text = "نصائح حديثة"
                    return cell
                }
                
            } else  {
                
                if ViewModel.mostViewedTipsArr?.count == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyTVCell", for: indexPath) as! EmptyTVCell
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVCell1", for: indexPath) as! HomeTVCell1
                    cell.nav =  self.navigationController
                    cell.layout.scrollDirection   = .horizontal
//                    cell.DataSourseDeledate()
                    cell.HViewCell.constant = 320
                    cell.indexx = indexPath.row
                    cell.ViewModel = ViewModel
                    cell.CollectionHome.reloadData()
                    
                    cell.BtnMore.isHidden   = false
                    cell.LaTitle.text = "النصائح الأكثر مشاهدة"
                    return cell
                }
            }
        }
    }
    
}

extension HomeVC {
    func GetMyProfile(){
        ViewModelProfile.GetMyProfile {[weak self] state in
            guard let self = self else{return}
            guard let state = state else{
                return
            }
            switch state {
            case .loading:
//                Hud.showHud(in: self.view,text: "")
                print("loading")
            case .stopLoading:
                Hud.dismiss(from: self.view)
            case .success:
                Hud.dismiss(from: self.view)
                print(state)
                if let user = ViewModelProfile.responseModel{
                    LaName.text  = user.name
                }
            case .error(_,let error):
                Hud.dismiss(from: self.view)
//                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self)
                print(error ?? "")
            case .none:
                print("")
            }
        }
    }
}


//--Functions--
extension HomeVC{
    func SetUserHeader(){
        LaName.text = "\(Helper.getUser()?.name ?? "")"
//        if let img = Helper.getUser()?.image {
//            //                let processor = SVGImgProcessor() // if receive svg image
//            ImgUser.kf.setImage(with: URL(string:Constants.baseURL + img.validateSlashs()), placeholder: UIImage(named: "defaultLogo"), options: nil, progressBlock: nil)
//        }

    }
    func getTipsCategories(){
        Task {
            do{
                Hud.showHud(in: self.view)
                ViewModel.newestTipsArr = try await ViewModel.GetNewestTips()
                ViewModel.mostViewedTipsArr = try await ViewModel.GetMostViewedTips()
                ViewModelMeasurements.ArrStats = try await ViewModelMeasurements.asyncGetMeasurementsStats()
                try await ViewModelHome.getHomeAlmostFinish()
                // Handle success async operations
                Hud.dismiss(from: self.view)
                TVScreen.reloadData()

                print("all",ViewModel.allTipsResModel?.items ?? [])
                print("interesting",ViewModel.interestingTipsArr ?? [])
                print("newest",ViewModel.newestTipsArr ?? [])
                print("mostview",ViewModel.mostViewedTipsArr ?? [])
                print("AlmostFinished",ViewModelHome.responseModel ?? AlmostFinishedPrescriptionM())
            } catch {
                // Handle any errors that occur during the async operations
                print("Error: \(error)")
                Hud.dismiss(from: self.view)
                SimpleAlert.shared.showAlert(title:error.localizedDescription , message:"" , viewController: self)
            }
        }
    }
    
    @objc func refreshData() {
        ViewModel.skipCount = 0
        ViewModelHome.skipCount = 0
        ViewModelMeasurements.skipCount = 0
        
        ViewModel.allTipsResModel?.items = []
        ViewModel.interestingTipsArr = []
        ViewModel.newestTipsArr = []
        ViewModel.mostViewedTipsArr = []
        ViewModelHome.responseModel?.items = []
        ViewModelMeasurements.ArrStats = []
        
        TVScreen.reloadData()
        // Place your refresh logic here, for example, fetch new data from your data source
        getTipsCategories()
        // When the refresh operation is complete, endRefreshing() to hide the refresh control
        refreshControl.endRefreshing()
    }
    
}
