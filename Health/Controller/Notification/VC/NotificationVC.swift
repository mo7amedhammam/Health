//
//  NotificationVC.swift
//  Health
//
//  Created by Hamza on 23/08/2023.
//

import UIKit

class NotificationVC: UIViewController {
    
    @IBOutlet weak var TVScreen: UITableView!
    
    @IBOutlet weak var ViewAddNewNotification: UIView!
    @IBOutlet weak var TFStartDate: UITextField!
    @IBOutlet weak var TFClock: UITextField!
    @IBOutlet weak var TFDrugName: UITextField!
    @IBOutlet weak var TFNumDrug: UITextField!
    @IBOutlet weak var TFNumDays: UITextField!
    @IBOutlet weak var TFEndDate: UITextField!
    
    @IBOutlet weak var ViewSelectDate: UIView!
    @IBOutlet weak var PickerDate: UIDatePicker!
    
    @IBOutlet weak var BtnClock: UIButton!
    @IBOutlet weak var BtnDay: UIButton!
    
    var selectDateFrom = ""
    let formatter = DateFormatter()
    let timePicker = UIDatePicker()

    let ViewModel = NotificationVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.PickerDate.addTarget(self, action: #selector(onDateValueChanged(_:)), for: .valueChanged)
        //
        timePicker.datePickerMode = .time
        // Create toolbar where a "Done" button will go
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        // Create Done button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(buttonTappedDone))
        toolbar.setItems([doneBtn], animated: true)
        // Assign toolbar to the top of the text field input view
        TFClock.inputAccessoryView = toolbar
        // Assign date picker as the input view for the text field
        TFClock.inputView = timePicker
        //
        ViewAddNewNotification.isHidden = true
        ViewSelectDate.isHidden         = true
        TVScreen.dataSource = self
        TVScreen.delegate = self
        TVScreen.registerCellNib(cellClass: NotificationTVCell.self)
//        TVScreen.reloadData()        
        ViewModel.maxResultCount = 10
        ViewModel.skipCount  = 0
        ViewModel.customerId =  Helper.getUser()?.id // they take it from token
        getNotifications()
        
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
         if selectDateFrom == "from" {
            TFStartDate.text = strDate
        } else if selectDateFrom == "to" {
            TFEndDate.text = strDate
        } else {
        }
        
        ViewSelectDate.isHidden = true
    }
    
    
    @IBAction func BUBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func BUConfirmAddNotification(_ sender: Any) {
        ViewAddNewNotification.isHidden = true
    }
    
    @IBAction func BUCancelAddNotification(_ sender: Any) {
        ViewAddNewNotification.isHidden = true
    }
    
    
    @IBAction func BUDayHour(_ sender: UIButton) {
        
        if sender.tag == 0 {
            BtnDay.isSelected = true
            BtnClock.isSelected = false
        } else {
            BtnDay.isSelected = false
            BtnClock.isSelected = true
        }
    }
    
    @objc private func buttonTappedDone(_ datePicker: UIDatePicker) {
        let selectedTime = timePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let formattedTime = dateFormatter.string(from: selectedTime)
        // Perform your desired actions with the selected time
        print("Selected time: \(formattedTime)")
        TFClock.text = formattedTime
        // Close date picker
        self.view.endEditing(true)
    }
    
    @IBAction func BUSelectStartClockEnd(_ sender: UIButton) {
        
        if sender.tag == 0 {
            selectDateFrom = "from"
            PickerDate.minimumDate = nil
            PickerDate.maximumDate = nil
            PickerDate.datePickerMode = .date
            ViewSelectDate.isHidden = false

        } else if sender.tag == 2 {
            //
            selectDateFrom = "to"
            if TFStartDate.text == "" {
                self.showAlert(message: "من فضلك حدد تاريخ البداية أولا")
            } else {
                let stringA = formattedDateFromString(dateString: TFStartDate.text! , withFormat: "yyyy")
                let stringB = formattedDateFromString(dateString: TFStartDate.text! , withFormat: "MM")
                let stringC = formattedDateFromString(dateString: TFStartDate.text! , withFormat: "dd")
                let calendar = Calendar.current
                var minDateComponent   = calendar.dateComponents([.day,.month,.year], from: Date())
                //                minDateComponent.day   = Int(stringC?.replacedArabicDigitsWithEnglish ?? "00")! + 1
                minDateComponent.day   = Int(stringC?.replacedArabicDigitsWithEnglish ?? "00")!
                minDateComponent.month = Int(stringB?.replacedArabicDigitsWithEnglish ?? "00")
                minDateComponent.year  = Int(stringA?.replacedArabicDigitsWithEnglish ?? "00")
                let minDate = calendar.date(from: minDateComponent)
                PickerDate.minimumDate    = minDate
                PickerDate.maximumDate    = Calendar.current.date(byAdding: .year, value: 10, to: Date())
                PickerDate.datePickerMode = .date
                
                ViewSelectDate.isHidden     = false
            }
            
        } else {
        }
        
        
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
    
    @IBAction func BUCancelSelectDateClock(_ sender: Any) {
        ViewSelectDate.isHidden = true
    }
    
    @IBAction func BUNotification(_ sender: Any) {
    }
    
    @IBAction func BUAddNewNoti(_ sender: Any) {
        ViewAddNewNotification.isHidden = false
    }
    
}

extension NotificationVC {
    
    
    func getNotifications() {
        
        ViewModel.GetNotifications { [self] state in
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
                TVScreen.reloadData()
                print(state)
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


extension NotificationVC : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewModel.ArrNotifications?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTVCell", for: indexPath) as! NotificationTVCell
        
        let model = ViewModel.ArrNotifications?.items![indexPath.row]

        
        if model?.notification == true {
            
            cell.ViewColor.backgroundColor = UIColor(named: "main")
            cell.View1.backgroundColor = UIColor(named: "secondary")
            cell.View2.backgroundColor = UIColor(named: "secondary")
            cell.View3.backgroundColor = UIColor(named: "secondary")
            cell.View4.backgroundColor = UIColor(named: "secondary")
            cell.View5.backgroundColor = UIColor(named: "secondary")
            cell.LaStatus.textColor    = UIColor(named: "secondary")
            //
            cell.ViewLine1.backgroundColor = .white
            cell.ViewLine2.backgroundColor = .white
            cell.ViewLine3.backgroundColor = .white
            cell.ViewLine4.backgroundColor = .white
            //
            cell.LaTitle.textColor = .white
            cell.LaClock.textColor = .white
            cell.LaEvery.textColor = .white
            cell.LaStartDate.textColor = .white
            cell.LaEndDate.textColor = .white
            cell.LaPeriod.textColor = .white
            cell.LLocClock.textColor = .white
            cell.LLocEvery.textColor = .white
            cell.LLocStartDate.textColor = .white
            cell.LLocEndDate.textColor = .white
            cell.LLocPeriod.textColor = .white
            cell.LaStatus.text = "فعّال"

            
        } else {
            
            cell.ViewColor.backgroundColor = UIColor(named: "FFE1E1")
            cell.View1.backgroundColor = UIColor(named: "wrong")
            cell.View2.backgroundColor = UIColor(named: "wrong")
            cell.View3.backgroundColor = UIColor(named: "wrong")
            cell.View4.backgroundColor = UIColor(named: "wrong")
            cell.View5.backgroundColor = UIColor(named: "wrong")
            cell.LaStatus.textColor    = UIColor(named: "wrong")
            //
            cell.ViewLine1.backgroundColor = UIColor(named: "halfwrong")
            cell.ViewLine2.backgroundColor = UIColor(named: "halfwrong")
            cell.ViewLine3.backgroundColor = UIColor(named: "halfwrong")
            cell.ViewLine4.backgroundColor = UIColor(named: "halfwrong")
            //
            cell.LaTitle.textColor = UIColor(named: "wrong")
            cell.LaClock.textColor = UIColor(named: "wrong")
            cell.LaEvery.textColor = UIColor(named: "wrong")
            cell.LaStartDate.textColor = UIColor(named: "wrong")
            cell.LaEndDate.textColor = UIColor(named: "wrong")
            cell.LaPeriod.textColor = UIColor(named: "wrong")
            cell.LLocClock.textColor = UIColor(named: "wrong")
            cell.LLocEvery.textColor = UIColor(named: "wrong")
            cell.LLocStartDate.textColor = UIColor(named: "wrong")
            cell.LLocEndDate.textColor = UIColor(named: "wrong")
            cell.LLocPeriod.textColor = UIColor(named: "wrong")
            
            cell.LaStatus.text = "مُنتهي"

        }
        
        cell.LaClock.text = model?.doseTimeTitle
        cell.LaTitle.text = model?.drugTitle
        cell.LaEvery.text = model?.doseQuantityTitle
        cell.LaClock.text = "\(model?.count ?? 0)"

        cell.LaPeriod.text = "\(model?.doseQuantityValue ?? 0 ) \(model?.doseTimeTitle ?? "" )"
        cell.LaStartDate.text = model?.startDate
        cell.LaEndDate.text = model?.endDate

        return cell
    }
    
}
