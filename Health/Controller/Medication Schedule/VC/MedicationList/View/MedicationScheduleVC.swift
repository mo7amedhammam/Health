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
        vc.modalPresentationStyle = .fullScreen
        vc.scheduleId = ViewModel.responseModel?.items?[indexPath.row].id
        self.present(vc, animated: false, completion: nil)
    }
    
}

//-- functions --
extension MedicationScheduleVC{
    
    func GetMedicationSchedule() {
//        ViewModel.skipCount = 0
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
