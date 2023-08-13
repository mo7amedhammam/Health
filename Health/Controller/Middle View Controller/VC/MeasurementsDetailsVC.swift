//
//  MeasurementsDetailsVC.swift
//  Health
//
//  Created by Hamza on 08/08/2023.
//

import UIKit

class MeasurementsDetailsVC: UIViewController {
    
    @IBOutlet weak var TVScreen: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        TVScreen.dataSource = self
        TVScreen.delegate   = self
        TVScreen.registerCellNib(cellClass: MeasurementsDetailsTVCell.self)
        TVScreen.registerCellNib(cellClass: MeasurementsDetailsTVCell0.self)
        TVScreen.reloadData()
    }
    
    
    @IBAction func BUBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func BuNotification(_ sender: Any) {
        
    }
    
    
}


extension MeasurementsDetailsVC : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeasurementsDetailsTVCell0", for: indexPath) as! MeasurementsDetailsTVCell0
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeasurementsDetailsTVCell", for: indexPath) as! MeasurementsDetailsTVCell
            
            if (indexPath.row - 1)  % 2 == 0 {
                cell.ViewColor.backgroundColor = UIColor(named: "06AD2B")
                cell.LaNum.textColor           = UIColor(named: "06AD2B")
                
                cell.LaDescription.text = "لا يوجد تعليق"
                cell.LaDescription.textColor = UIColor(named: "deactive")
            } else {
                cell.ViewColor.backgroundColor = UIColor(named: "EE2E3A")
                cell.LaNum.textColor           = UIColor(named: "EE2E3A")
                
                cell.LaDescription.text = "تم القياس بعد أكل كمية من السكريات تم أكل كمية كبيرة من الأملاح في هذا اليوم"
                cell.LaDescription.textColor = UIColor(named: "main")
            }
            return cell
        }
    }
    
    
}
