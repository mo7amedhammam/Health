//
//  MeasurementsDetailsVC.swift
//  Health
//
//  Created by Hamza on 08/08/2023.
//

import UIKit

class MeasurementsDetailsVC: UIViewController {
    
    @IBOutlet weak var TVScreen: UITableView!
    
    
    @IBOutlet weak var ViewAddMeasurement: UIView!
    @IBOutlet weak var TFNumMeasure: UITextField!
    @IBOutlet weak var TFDate: UITextField!
    @IBOutlet weak var TVDescription: TextViewWithPlaceholder!
    
    @IBOutlet weak var ViewSelectDate: UIView!
    
    @IBOutlet weak var PickerDate: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        TVScreen.dataSource = self
        TVScreen.delegate   = self
        TVScreen.registerCellNib(cellClass: MeasurementsDetailsTVCell.self)
        TVScreen.registerCellNib(cellClass: MeasurementsDetailsTVCell0.self)
        TVScreen.reloadData()
        
        ViewSelectDate.isHidden     = true
        ViewAddMeasurement.isHidden = true

    }
    
    
    @IBAction func BUBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func BuNotification(_ sender: Any) {
        
    }
    
    
    
    @IBAction func BUSelectDate(_ sender: Any) {
        ViewSelectDate.isHidden = false
    }
    @IBAction func BUCancelSelectDate(_ sender: Any) {
        ViewSelectDate.isHidden = true
    }
    
    @IBAction func BUConfirmAdd(_ sender: Any) {
        ViewAddMeasurement.isHidden = true
    }
        
    @IBAction func BUCancelAdd(_ sender: Any) {
        ViewAddMeasurement.isHidden = true
    }
    
    
}


extension MeasurementsDetailsVC : UITableViewDataSource , UITableViewDelegate , MeasurementsDetailsTVCell0_Protocoal {
    
    
    func AllMeasurement() {
        
    }
    
    func TearMonthDay(tag: Int) {
        
    }
    
    func Search() {
        
    }
    
    func AddMeasurement() {
        ViewAddMeasurement.isHidden = false
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeasurementsDetailsTVCell0", for: indexPath) as! MeasurementsDetailsTVCell0
            
            cell.delegate = self
            
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
