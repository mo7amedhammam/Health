//
//  MedicationScheduleVC.swift
//  Health
//
//  Created by Hamza on 06/08/2023.
//

import UIKit

class MedicationScheduleVC: UIViewController {

    @IBOutlet weak var TVScreen: UITableView!

    let ViewModel = MedicationScheduleVM()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TVScreen.dataSource = self
        TVScreen.delegate = self
        TVScreen.registerCellNib(cellClass: MedicationScheduleTVCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GetMedicationSchedule()
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
    
        let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last
        guard let modelarr = ViewModel.responseModel?.items else {return}
        if let lastVisibleCell = lastVisibleIndexPath, lastVisibleCell.row == modelarr.count - 1 {
            if modelarr.count > 0  {
                    self.loadNextPage()
            }
        }
    }
    func loadNextPage(){
        guard (ViewModel.responseModel?.totalCount ?? 0) > (ViewModel.responseModel?.items?.count ?? 0) , ViewModel.cansearch == true else {return}
        ViewModel.skipCount = ViewModel.responseModel?.items?.count
        GetMedicationSchedule()
    }

}

//-- functions --
extension MedicationScheduleVC{
    
    func GetMedicationSchedule() {
        ViewModel.GetMySchedulePrescriptions{[self] state in
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
// -- go to home
                TVScreen.reloadData()
                
            case .error(_,let error):
                Hud.dismiss(from: self.view)
                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self)
                print(error ?? "")
            case .none:
                print("")
            }
        }
    }
}
