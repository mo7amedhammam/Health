//
//  MedicationScheduleDetailsVC.swift
//  Health
//
//  Created by Hamza on 06/08/2023.
//

import UIKit

class MedicationScheduleDetailsVC: UIViewController {

    @IBOutlet weak var TVScreen: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TVScreen.dataSource = self
        TVScreen.delegate = self
        TVScreen.registerCellNib(cellClass: MedicationScheduleDetailsTVCell.self)
        TVScreen.reloadData()
        
    }
    
    @IBAction func BUBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func BUNotification(_ sender: Any) {

    }
    
    

}


extension MedicationScheduleDetailsVC : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationScheduleDetailsTVCell", for: indexPath) as! MedicationScheduleDetailsTVCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      
    }
    
}
