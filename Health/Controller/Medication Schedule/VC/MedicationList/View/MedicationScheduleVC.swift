//
//  MedicationScheduleVC.swift
//  Health
//
//  Created by Hamza on 06/08/2023.
//

import UIKit

class MedicationScheduleVC: UIViewController {

    @IBOutlet weak var TVScreen: UITableView!
    let refreshControl = UIRefreshControl()
    let ViewModel = MedicationScheduleVM()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TVScreen.dataSource = self
        TVScreen.delegate = self
        TVScreen.registerCellNib(cellClass: MedicationScheduleTVCell.self)
        GetMedicationSchedule()
        
        // Configure the refresh control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        // Add the refresh control to the collection view
        TVScreen.addSubview(refreshControl)
        
        // Load your initial data here (e.g., fetchData())
        refreshData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        GetMedicationSchedule()
    }
//    @IBAction func BUBack(_ sender: Any) {
//        self.dismiss(animated: true)
//    }
    
    @IBAction func BUNotification(_ sender: Any) {

    }
    
}

// -- tableView --
extension MedicationScheduleVC : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewModel.responseModel?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationScheduleTVCell", for: indexPath) as! MedicationScheduleTVCell
        
        cell.SchedualModel = ViewModel.responseModel?.items?[indexPath.row] ?? MedicationScheduleItem()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MedicationScheduleDetailsVC") as! MedicationScheduleDetailsVC
        vc.schedualM = ViewModel.responseModel?.items?[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Check if the last visible cell is close to the end of the table view
        guard let model = ViewModel.responseModel else {return}
            if indexPath.row == (model.items?.count ?? 0) - 1 {
                if let totalCount = model.totalCount, let itemsCount = model.items?.count, itemsCount < totalCount{
                    self.loadNextPage(itemsCount)
            }
        }
    }
    func loadNextPage(_ skipCount:Int){
        ViewModel.skipCount = skipCount
        GetMedicationSchedule()
    }

}

//-- functions --
extension MedicationScheduleVC{
    
    func GetMedicationSchedule() {
        CloseView_NoContent()
        ViewModel.GetMySchedulePrescriptions{[weak self] state in
            guard let self = self else{return}
            guard let state = state else{
                return
            }
            switch state {
            case .loading:
                Hud.showHud(in: self.view)
            case .stopLoading:
                Hud.dismiss(from: self.view)
            case .success:
                Hud.dismiss(from: self.view)
                print(state)
                if ViewModel.responseModel?.items?.count == 0 || ViewModel.responseModel?.items == nil {
                    LoadView_NoContent(Superview: TVScreen, title:  "لا يوجد اي جدول " , img: "noscheduals")
                } else {
                    CloseView_NoContent()
                    TVScreen.reloadData()
                }
                
            case .error(_,let error):
                Hud.dismiss(from: self.view)
                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self)
                print(error ?? "")
            case .none:
                print("")
            }
        }
    }
    
    @objc func refreshData(){
        ViewModel.skipCount = 0
        GetMedicationSchedule()
        refreshControl.endRefreshing()
    }
    
}
