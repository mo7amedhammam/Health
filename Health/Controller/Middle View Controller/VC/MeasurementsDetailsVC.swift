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
    
    // to fill lable in cell0
    var CellDateFrom = ""
    var CellDateTo   = ""
    //
    var selectDateFrom = ""
    let formatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.PickerDate.addTarget(self, action: #selector(onDateValueChanged(_:)), for: .valueChanged)
        TVScreen.dataSource = self
        TVScreen.delegate   = self
        TVScreen.registerCellNib(cellClass: MeasurementsDetailsTVCell.self)
        TVScreen.registerCellNib(cellClass: MeasurementsDetailsTVCell0.self)
        TVScreen.reloadData()
        ViewSelectDate.isHidden     = true
        ViewAddMeasurement.isHidden = true
        
    }
    
    
    @objc private func onDateValueChanged(_ datePicker: UIDatePicker) {
        //do something here
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale     = Locale(identifier: "en_US_POSIX")
        let strDate = formatter.string(from: datePicker.date )
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        self.view.endEditing(true)
        print(strDate)
        
        if selectDateFrom == "new" {
            TFDate.text = strDate
        } else if selectDateFrom == "from" {
            CellDateFrom = strDate
            let indexPath = IndexPath(row: 0, section: 0)
            TVScreen.reloadRows(at: [indexPath], with: .automatic)
        } else if selectDateFrom == "to" {
            CellDateTo = strDate
            let indexPath = IndexPath(row: 0, section: 0)
            TVScreen.reloadRows(at: [indexPath], with: .automatic)
        } else {
        }
        
        ViewSelectDate.isHidden = true
    }
    
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = NSLocale.init(localeIdentifier: "en") as Locale
        inputFormatter.dateFormat = "yyyy/MM/dd"
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            return outputFormatter.string(from: date)
        }
        return nil
    }
    
    
    
    @IBAction func BUBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func BuNotification(_ sender: Any) {
        
    }
    
    @IBAction func BUSelectDate(_ sender: Any) {

        PickerDate.minimumDate = nil
        PickerDate.maximumDate = nil
        
        selectDateFrom = "new"
        ViewSelectDate.isHidden = false
    }
    @IBAction func BUCancelSelectDate(_ sender: Any) {
        selectDateFrom = ""
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
    
    
    
    func FromDateToDate(select: String  , LaDateFrom : UILabel) {
        
        if select == "from" {
            PickerDate.minimumDate = nil
            PickerDate.maximumDate = nil
            
            ViewSelectDate.isHidden     = false
            selectDateFrom = "from"
        } else {
            if LaDateFrom.text == "" {
                self.showAlert(message: "من فضلك حدد تاريخ البداية أولا")
            } else {
                
                let stringA = formattedDateFromString(dateString: CellDateFrom , withFormat: "yyyy")
                let stringB = formattedDateFromString(dateString: CellDateFrom , withFormat: "MM")
                let stringC = formattedDateFromString(dateString: CellDateFrom , withFormat: "dd")
                let calendar = Calendar.current
                var minDateComponent   = calendar.dateComponents([.day,.month,.year], from: Date())
                //                minDateComponent.day   = Int(stringC?.replacedArabicDigitsWithEnglish ?? "00")! + 1
                minDateComponent.day   = Int(stringC?.replacedArabicDigitsWithEnglish ?? "00")!
                minDateComponent.month = Int(stringB?.replacedArabicDigitsWithEnglish ?? "00")
                minDateComponent.year  = Int(stringA?.replacedArabicDigitsWithEnglish ?? "00")
                let minDate = calendar.date(from: minDateComponent)
                PickerDate.minimumDate    = minDate
                PickerDate.maximumDate    = Calendar.current.date(byAdding: .year, value: 10, to: Date())

             
                
                ViewSelectDate.isHidden     = false
                selectDateFrom = "to"
            }
        }
    }
    
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
            
            if CellDateFrom == "" {
                cell.LaDateFrom.text = ""
                cell.LaDateFrom.isHidden = true
            } else {
                cell.LaDateFrom.text = CellDateFrom
                cell.LaDateFrom.isHidden = false
            }
            
            if CellDateTo == "" {
                cell.LaDateTo.text = ""
                cell.LaDateTo.isHidden = true
            } else {
                cell.LaDateTo.text   = CellDateTo
                cell.LaDateTo.isHidden = false
            }
            
            if selectDateFrom == "from" {
                cell.LaDateTo.text = ""
                cell.LaDateTo.isHidden = true
            }
            
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
