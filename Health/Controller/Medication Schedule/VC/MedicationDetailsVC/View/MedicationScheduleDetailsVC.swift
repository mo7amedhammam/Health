//
//  MedicationScheduleDetailsVC.swift
//  Health
//
//  Created by Hamza on 06/08/2023.
//

import UIKit

class MedicationScheduleDetailsVC: UIViewController {

    @IBOutlet weak var TVScreen: UITableView!
    @IBOutlet weak var LaStartDate: UILabel!
    @IBOutlet weak var LaEndDate: UILabel!
    @IBOutlet weak var LaDrugsCount: UILabel!
    @IBOutlet weak var LaRenewalDate: UILabel!
    
    @IBOutlet weak var LaTitleBare: UILabel!

    
    var schedualM:MedicationScheduleItem? = MedicationScheduleItem()
    let ViewModel = MedicationScheduleDetailsVM()
    var TitleBare = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        LaTitleBare.text = TitleBare
        // Do any additional setup after loading the view.
        TVScreen.dataSource = self
        TVScreen.delegate = self
        TVScreen.registerCellNib(cellClass: MedicationScheduleDetailsTVCell.self)
        SetCurrentSched()
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
    func SetCurrentSched(){
         let model = schedualM
            LaStartDate.text = model?.startDate?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd/MM/yyyy")
            LaEndDate.text = model?.endDate?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd/MM/yyyy")
            LaRenewalDate.text = model?.renewDate?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd/MM/yyyy hh:mm a")
            LaDrugsCount.text = "\(model?.drugsCount ?? 0)"
    }
    
    func GetMedicationScheduleDrugs() {
        guard let model = schedualM else {return}
        ViewModel.scheduleId = model.id
        ViewModel.GetMyScheduleDrugs{[weak self] state in
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
