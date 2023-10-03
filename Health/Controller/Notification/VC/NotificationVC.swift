//
//  NotificationVC.swift
//  Health
//
//  Created by Hamza on 23/08/2023.
//

import UIKit
import DropDown


class NotificationVC: UIViewController {
    
    
    @IBOutlet weak var BtnSelectDrug: UIButton!
    
    @IBOutlet weak var TVScreen: UITableView!
    let refreshControl = UIRefreshControl()
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
    var ArrDrugString = [String]()
    var drugId = 0
    let rightBarDropDown = DropDown()
    var doseTimeId = 0 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TFDrugName.delegate = self
        rightBarDropDown.anchorView = TFDrugName
        rightBarDropDown.cancelAction = { [self] in
            BtnSelectDrug.isSelected = false
        }
                
        self.PickerDate.addTarget(self, action: #selector(onDateValueChanged(_:)), for: .valueChanged)
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
        getDrugs()
        
        
        // Configure the refresh control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        // Add the refresh control to the collection view
        TVScreen.addSubview(refreshControl)
        
        // Load your initial data here (e.g., fetchData())
        refreshData()

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
    
    @IBAction func BUSelectDrug(_ sender: Any) {
                
        rightBarDropDown.dataSource = ArrDrugString
        rightBarDropDown.selectionAction = { [self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.TFDrugName.text = ArrDrugString[index]
            BtnSelectDrug.isSelected = false
            drugId = ViewModel.ArrDrugs[index].id ?? 0
            print("drugId : \(drugId)")
        }
        BtnSelectDrug.isSelected = true
        let preferredViewWidth = TFDrugName.frame.size.width // Assuming ViewPreferred is a UIView
        rightBarDropDown.width = preferredViewWidth
        rightBarDropDown.bottomOffset = CGPoint(x: -10 , y: (rightBarDropDown.anchorView?.plainView.bounds.height)!)
        rightBarDropDown.show()
        
    }
    
    
    @IBAction func BUConfirmAddNotification(_ sender: Any) {
        
        if TFDrugName.text == "" {
            self.showAlert(message: "من فضلك ادخل اسم الدواء او قم باختيارة من القائمة")
        } else  if TFStartDate.text == "" {
            self.showAlert(message: "من فضلك ادخل تاريخ البداية")
        } else  if TFEndDate.text == "" {
            self.showAlert(message: "من فضلك ادخل تاريخ النهاية")
        } else  if TFClock.text == "" {
            self.showAlert(message: "من فضلك ادخل الساعة")
        } else  if TFNumDays.text == "" {
            self.showAlert(message: "من فضلك ادخل عدد الايام ")
        } else  if TFNumDrug.text == "" {
            self.showAlert(message: "من فضلك ادخل عدد مرات اخذ الدواء ")
        } else if doseTimeId == 0 {
            self.showAlert(message: "من فضلك قم باختيار الدواء كل ساعة ام كل يوم ")
        } else {
            // create
            CreateNotification()
        }
                
    }
    
    @IBAction func BUCancelAddNotification(_ sender: Any) {
        ViewAddNewNotification.isHidden = true
    }
    
    
    @IBAction func BUDayHour(_ sender: UIButton) {
        
        if sender.tag == 0 {
            BtnDay.isSelected = true
            BtnClock.isSelected = false
            doseTimeId = 1
        } else {
            BtnDay.isSelected = false
            BtnClock.isSelected = true
            doseTimeId = 2
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
        
        ViewModel.GetNotifications { [weak self] state in
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
    
    @objc func refreshData(){
        ViewModel.skipCount = 0
        getNotifications()
        refreshControl.endRefreshing()
    }
    
    func getDrugs() {
        
        ViewModel.GetDrugs { [weak self] state in
            guard let self = self else{return}
            guard let state = state else{
                return
            }
            switch state {
            case .loading:
//                Hud.showHud(in: self.view)
                print(state)
            case .stopLoading:
//                Hud.dismiss(from: self.view)
                print(state)
            case .success:
//                Hud.dismiss(from: self.view)
                print(state)
                for data in ViewModel.ArrDrugs {
                    ArrDrugString.append(data.title ?? "" )
                }
                print("ArrDrugString.count : \(ArrDrugString.count)")
            case .error(_,let error):
//                Hud.dismiss(from: self.view)
//                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self)
                print(error ?? "")
            case .none:
                print("")
            }
        }
    }
    
    func CreateNotification () {
        
        if drugId == 0 {
            ViewModel.otherDrug = TFDrugName.text!
            ViewModel.drugId = 0
        } else {
            ViewModel.drugId = drugId
        }
        ViewModel.count      = Int(TFNumDrug.text!)!
        ViewModel.customerId =  Helper.getUser()?.id // they take it from token
        ViewModel.doseTimeId = doseTimeId // day 1 hour 2
        ViewModel.days       = Int(TFNumDays.text!)!
//        ViewModel.doseQuantityId = 0
        ViewModel.notification = true
        ViewModel.startDate    = TFStartDate.text!
        ViewModel.endDate      = TFEndDate.text!
        
        
        ViewModel.CreateNotification { [weak self] state in
            guard let self = self,let state = state else{
                return
            }
            switch state {
            case .loading:
                Hud.showHud(in: self.view)
            case .stopLoading:
                Hud.dismiss(from: self.view)
            case .success:
                 ViewAddNewNotification.isHidden = true
                Hud.dismiss(from: self.view)
                SimpleAlert.shared.showAlert(title: "تم إضافة تنبية جديد"  ,message: "", viewController: self)
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
        cell.LaEvery.text =  "\(model?.count ?? 0 ) \(model?.doseTimeTitle ?? "" )"
        cell.LaClock.text = "\(model?.count ?? 0)"

        cell.LaPeriod.text = "\(model?.days ?? 0) أيام"
        cell.LaStartDate.text = model?.startDate?.CangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd/MM/yyyy")
        cell.LaEndDate.text = model?.endDate?.CangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd/MM/yyyy")

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let model = ViewModel.ArrNotifications else{return}
        if indexPath.row == (model.items?.count ?? 0) - 1 {
            // Check if the last cell is about to be displayed
            if let totalCount = model.totalCount, let itemsCount = model.items?.count, itemsCount < totalCount {
                loadNextPage(itemsCount)
            }
        }
    }
    
    func loadNextPage(_ skipCount:Int){
        ViewModel.skipCount = skipCount
        getNotifications()
    }
}




extension NotificationVC : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == TFDrugName {
            drugId = 0
            print("drugId is zero : \(drugId)")
        }
    }
}
