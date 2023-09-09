//
//  MedicationScheduleDetailsVC.swift
//  Health
//
//  Created by Hamza on 06/08/2023.
//

import UIKit

class MedicationScheduleDetailsVC: UIViewController {

    @IBOutlet weak var TVScreen: UITableView!
    var scheduleId : Int? = 0
    var schedualM = MedicationScheduleM()
    let ViewModel = MedicationScheduleDetailsVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TVScreen.dataSource = self
        TVScreen.delegate = self
        TVScreen.registerCellNib(cellClass: MedicationScheduleDetailsTVCell.self)
//        TVScreen.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GetMedicationScheduleDrugs()
    }
    
    @IBAction func BUBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func BUNotification(_ sender: Any) {

    }

}


extension MedicationScheduleDetailsVC : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewModel.responseModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationScheduleDetailsTVCell", for: indexPath) as! MedicationScheduleDetailsTVCell
        cell.DrugModel = ViewModel.responseModel?[indexPath.row] ?? MedicationScheduleDrugM()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      
    }
    
}

extension MedicationScheduleDetailsVC {
    func GetMedicationScheduleDrugs() {
        ViewModel.scheduleId = scheduleId
        ViewModel.GetMyScheduleDrugs{[self] state in
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
