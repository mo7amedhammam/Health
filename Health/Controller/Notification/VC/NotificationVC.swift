//
//  NotificationVC.swift
//  Health
//
//  Created by Hamza on 23/08/2023.
//

import UIKit
import DropDown
import Foundation

class NotificationVC: UIViewController  {
    
    
    @IBOutlet weak var BtnSelectDrug: UIButton!
    @IBOutlet weak var BtnBack: UIButton!
    @IBOutlet weak var TVScreen: UITableView!
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var ViewAddNewNotification: UIView!
    @IBOutlet weak var BtnAddNewMes: UIButton!
    @IBOutlet weak var TFStartDate: UITextField!
    @IBOutlet weak var TFClock: UITextField!
    @IBOutlet weak var TFDrugName: UITextField!
    @IBOutlet weak var TFNumDrug: UITextField!
    @IBOutlet weak var TFNumDays: UITextField!
    @IBOutlet weak var TFEndDate: UITextField!
    @IBOutlet weak var LaFor: UILabel!
    @IBOutlet weak var LaDays: UILabel!

    @IBOutlet weak var ViewSelectDate: UIView!
    @IBOutlet weak var PickerDate: UIDatePicker!
                   
    @IBOutlet weak var BtnClock: UIButton!
    @IBOutlet weak var BtnDay: UIButton!
    
    var selectDateFrom = ""
    let formatter = DateFormatter()
    var timePicker = UIDatePicker()

    let ViewModel = NotificationVM()
    var ArrDrugString = [String]()
    var ArrDrugStringSearch = [String]()
    var drugId = 0
    let rightBarDropDown = DropDown()
    var doseTimeId = 0
    var ClockAmPm = ""
    
    var NewDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PickerDate.minimumDate = Date()
        PickerDate.maximumDate = nil
        PickerDate.datePickerMode = .date
        PickerDate.date = Date()
        
        TFNumDays.keyboardType = .asciiCapableNumberPad
        TFNumDrug.keyboardType = .asciiCapableNumberPad

//        TFNumDays.delegate = self
        TFNumDays.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        TFClock.delegate = self

        TFDrugName.delegate = self
        TFDrugName.addTarget(self , action: #selector(self.EditingChanged(_:)), for: .editingChanged)
        
        rightBarDropDown.anchorView = TFDrugName
        rightBarDropDown.cancelAction = { [self] in
            BtnSelectDrug.isSelected = false
        }
                
        timePicker = UIDatePicker()
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
//        TFClock.inputView = timePicker
        //
        ViewAddNewNotification.isHidden = true
        ViewSelectDate.isHidden         = true
        TVScreen.dataSource = self
        TVScreen.delegate = self
        TVScreen.registerCellNib(cellClass: NotificationTVCell.self)
        // Configure the refresh control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        // Add the refresh control to the collection view
        TVScreen.addSubview(refreshControl)
        // Load your initial data here (e.g., fetchData())
//        refreshData()
//        getDrugs()
        setupUI()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        BtnAddNewMes.titleLabel?.font = UIFont(name: fontsenum.bold.rawValue, size: 24)!
    }
    override func viewWillAppear(_ animated: Bool) {
        ViewModel.maxResultCount = 10
        ViewModel.skipCount  = 0
        ViewModel.customerId =  Helper.shared.getUser()?.id // they take it from token
        ViewModel.ArrNotifications?.items?.removeAll()
        TVScreen.reloadData()
        getNotifications()
        //
        ArrDrugString.removeAll()
        ArrDrugStringSearch.removeAll()
        getDrugs()

    }
    
    func setupUI(){
        let isRTL = Helper.shared.getLanguage() == "ar"
        if isRTL {
            LaDays.reverselocalizedview()
        }else{
            LaFor.reverselocalizedview()
        }
        BtnBack.setImage(UIImage(resource: .backLeft).flippedIfRTL, for: .normal)

    }
    
    @objc func EditingChanged (_ textField: UITextField) {
        
        if textField.text == "" {
            ArrDrugStringSearch.removeAll()
            ArrDrugStringSearch = ArrDrugString
            drugId = 0
        } else {
            drugId = 0 // if text entered not found in array 
            if let searchText = TFDrugName.text {
                ArrDrugStringSearch = ArrDrugString.filter { $0.localizedStandardContains(searchText) }
            }
        }
        
        rightBarDropDown.dataSource = ArrDrugStringSearch
        rightBarDropDown.selectionAction = { [self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.TFDrugName.text = ArrDrugStringSearch[index]
            BtnSelectDrug.isSelected = false
            
            for data in ViewModel.ArrDrugs {
                if data.title == ArrDrugStringSearch[index] {
                    drugId = data.id ?? 0
                    print("id : \(data.id) title : \(data.title)")
                }
            }
//                        drugId = ViewModel.ArrDrugs[index].id ?? 0
        }
        BtnSelectDrug.isSelected = true
        let preferredViewWidth = TFDrugName.frame.size.width // Assuming ViewPreferred is a UIView
        rightBarDropDown.width = preferredViewWidth
        rightBarDropDown.bottomOffset = CGPoint(x: -10 , y: (rightBarDropDown.anchorView?.plainView.bounds.height)!)
        rightBarDropDown.show()
    }
   
    
    
    @IBAction func BUDoneSelectDate(_ sender: Any) {
        //do something here
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale     = Locale(identifier: "en_US_POSIX")
        let strDate = formatter.string(from: PickerDate.date )
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        self.view.endEditing(true)
        print(strDate)
        
        let FF = DateFormatter()
        FF.dateFormat = "yyyy-MM-dd"
        FF.locale     = Locale(identifier: "en_US_POSIX")
        let NN = FF.string(from: PickerDate.date )
        FF.dateStyle = .medium
        FF.timeStyle = .none
        NewDate = NN
        print("NewDate : \(NewDate)")
        
        if selectDateFrom == "from" {
            TFStartDate.text = strDate

            if TFNumDays.text == "" {
                // Handle the case where TFNumDays.text is empty
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")

                if let date = dateFormatter.date(from: NN) {
                    var dateComponents = DateComponents()
                    if let numDays = Int(TFNumDays.text!.convertedDigitsToLocale(Locale(identifier: "EN"))) {
                        dateComponents.day = numDays

                        let calendar = Calendar.current
                        if let newDate = calendar.date(byAdding: dateComponents, to: date) {
                            let newDateString = dateFormatter.string(from: newDate)
                            print("newDateString: \(newDateString)")
                            TFEndDate.text = newDateString
                        } else {
                            // Handle the case where calculating new date failed
                        }
                    } else {
                        // Handle the case where converting TFNumDays.text to an integer failed
                    }
                } else {
                    // Handle the case where NN couldn't be converted to a date
                }
            }
        }

        
//         if selectDateFrom == "from" {
//            TFStartDate.text = strDate
//
//             if TFNumDays.text == "" {
//
//             } else {
//                 let dateFormatter = DateFormatter()
//                 dateFormatter.dateFormat = "dd/MM/yyyy"
//                 dateFormatter.locale     = Locale(identifier: "en_US_POSIX")
//                 let date = dateFormatter.date(from: NN)!
//                 var dateComponents = DateComponents()
//                 dateComponents.day = Int(TFNumDays.text!.convertedDigitsToLocale(Locale(identifier: "EN")) )!
//                 let calendar = Calendar.current
//                 let newDate = calendar.date(byAdding: dateComponents, to: date)!
//                 let newDateString = dateFormatter.string(from: newDate)
//                 print("newDateString : \(newDateString)")
//                 TFEndDate.text = newDateString
//             }
//        } else if selectDateFrom == "to" {
////            TFEndDate.text = strDate
//        } else {
//        }
        
        ViewSelectDate.isHidden = true
        
    }
    
    
    
    @IBAction func BUBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true)
    }
    
    @IBAction func BUSelectDrug(_ sender: Any) {
        
        if BtnSelectDrug.isSelected == true {
            BtnSelectDrug.isSelected = false
            rightBarDropDown.hide()
            ArrDrugStringSearch.removeAll()
            ArrDrugStringSearch = ArrDrugString
        } else {
            rightBarDropDown.dataSource = ArrDrugStringSearch
            rightBarDropDown.selectionAction = { [self] (index: Int, item: String) in
                print("Selected item: \(item) at index: \(index)")
                self.TFDrugName.text = ArrDrugStringSearch[index]
                BtnSelectDrug.isSelected = false
                drugId = ViewModel.ArrDrugs[index].id ?? 0
                print("id : \(drugId) title : \(ArrDrugStringSearch[index])")
            }
            BtnSelectDrug.isSelected = true
            let preferredViewWidth = TFDrugName.frame.size.width // Assuming ViewPreferred is a UIView
            rightBarDropDown.width = preferredViewWidth
            rightBarDropDown.bottomOffset = CGPoint(x: -10 , y: (rightBarDropDown.anchorView?.plainView.bounds.height)!)
            rightBarDropDown.show()
        }
                
    }
    
    
    @IBAction func BUConfirmAddNotification(_ sender: Any) {
        
        if TFDrugName.text == "" {
            self.showAlert(message: "من فضلك ادخل اسم الدواء او قم باختيارة من القائمة")
        } else  if NewDate == "" {
            self.showAlert(message: "من فضلك ادخل تاريخ البداية")
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
        ClockAmPm = ""
        TFClock.text = ""
        TFEndDate.text = ""
        TFNumDays.text = ""
        TFStartDate.text = ""
        NewDate = ""
        TFNumDrug.text = ""
        TFDrugName.text = ""
        drugId = 0
        BtnDay.isSelected = false
        BtnClock.isSelected = false
        ArrDrugStringSearch.removeAll()
        ArrDrugStringSearch = ArrDrugString
        ViewAddNewNotification.isHidden = true
        
        PickerDate.minimumDate  = Date()
        PickerDate.maximumDate  = nil
        PickerDate.date = Date()
        
        self.view.endEditing(true)
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
    
    @IBAction func BUSelectTime(_ sender: UIButton) {
        // Show the time picker
        
        if TFClock.text == "" {
            timePicker = UIDatePicker()
            timePicker.datePickerMode = .time
            TFClock.inputView = timePicker
            TFClock.becomeFirstResponder()
        } else {
            TFClock.inputView = timePicker
            TFClock.becomeFirstResponder()
        }
    }
    
    @objc private func buttonTappedDone(_ datePicker: UIDatePicker) {
        let selectedTime = timePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.init(localeIdentifier: "en_US_POSIX") as Locale
        dateFormatter.dateFormat = "hh:mm a"
        let formattedTime = dateFormatter.string(from: selectedTime)
        // Perform your desired actions with the selected time
        print("Selected time: \(formattedTime)")
        TFClock.text = formattedTime
        // Close date picker
        let forma = DateFormatter()
        forma.dateFormat = "HH:mm"
        forma.locale     = Locale(identifier: "en")
        let strForma = forma.string(from: selectedTime )
        ClockAmPm = "T\(strForma)"

        print("ClockAmPm : \(ClockAmPm)")
        print("ClockAmPm : \(ClockAmPm)")
        TFClock.resignFirstResponder() // Dismiss the keyboard
    }
    
    @IBAction func BUSelectStartClockEnd(_ sender: UIButton) {
        
        if sender.tag == 0 {
            selectDateFrom = "from"
//            let calendar   = Calendar.current
//            var components = DateComponents()
//            components.day = -1
//            let yesterday  = calendar.date(byAdding: components, to: Date())!
//            PickerDate.date = yesterday
            
            self.view.endEditing(true)

            ViewSelectDate.isHidden = false

        } else if sender.tag == 2 {
            // hash this code , cant select second date
            // second date calculated from start date + number of days
            
//            selectDateFrom = "to"
//            if TFStartDate.text == "" {
//                self.showAlert(message: "من فضلك حدد تاريخ البداية أولا")
//            } else {
//                let stringA = formattedDateFromString(dateString: TFStartDate.text! , withFormat: "yyyy")
//                let stringB = formattedDateFromString(dateString: TFStartDate.text! , withFormat: "MM")
//                let stringC = formattedDateFromString(dateString: TFStartDate.text! , withFormat: "dd")
//                let calendar = Calendar.current
//                var minDateComponent   = calendar.dateComponents([.day,.month,.year], from: Date())
//                //                minDateComponent.day   = Int(stringC?.replacedArabicDigitsWithEnglish ?? "00")! + 1
//                minDateComponent.day   = Int(stringC?.replacedArabicDigitsWithEnglish ?? "00")!
//                minDateComponent.month = Int(stringB?.replacedArabicDigitsWithEnglish ?? "00")
//                minDateComponent.year  = Int(stringA?.replacedArabicDigitsWithEnglish ?? "00")
//                let minDate = calendar.date(from: minDateComponent)
//                PickerDate.minimumDate    = minDate
//                PickerDate.maximumDate    = Calendar.current.date(byAdding: .year, value: 10, to: Date())
//                PickerDate.datePickerMode = .date
//
//                ViewSelectDate.isHidden     = false
//            }
            
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
        PickerDate.minimumDate  = Date()
        PickerDate.maximumDate  = nil
        PickerDate.date = Date()

    }
    
    @IBAction func BUNotification(_ sender: Any) {
    }
    
    @IBAction func BUAddNewNoti(_ sender: Any) {
        ViewAddNewNotification.isHidden = false
    }
    
    @IBAction func BUHideAddNewNoti(_ sender: Any) {
        ViewAddNewNotification.isHidden = true
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
                
                CloseView_NoContent()
                
                if ViewModel.ArrNotifications?.items == nil || ViewModel.ArrNotifications?.items?.count == 0  {
                    LoadView_NoContent(Superview: TVScreen, title: "لا يوجد أي تنبيهات ", img: "nonotification")
                } else {
                    TVScreen.reloadData()
                }
                
                Hud.dismiss(from: self.view)
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
    
    @objc func refreshData() {
        ViewModel.skipCount = 0
        ViewModel.ArrNotifications?.items?.removeAll()
        TVScreen.reloadData()
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
                ArrDrugStringSearch = ArrDrugString
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
        ViewModel.count      = Int(TFNumDrug.text!.convertedDigitsToLocale(Locale(identifier: "EN")))!
        ViewModel.customerId =  Helper.shared.getUser()?.id // they take it from token
        ViewModel.doseTimeId = doseTimeId // day 1 hour 2
        ViewModel.days       = Int(TFNumDays.text!.convertedDigitsToLocale(Locale(identifier: "EN")) )!
//        ViewModel.doseQuantityId = 0
        ViewModel.notification = true
        ViewModel.startDate    = "\(NewDate)\(ClockAmPm)"
        ViewModel.endDate      =  "\(TFEndDate.text!)"
        
        print("::::::: \(NewDate)\(ClockAmPm)")
        print("::::::: \(TFEndDate.text!)\(ClockAmPm) ")

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
                
                // to set current time again
                timePicker = UIDatePicker()
                timePicker.datePickerMode = .time
                //to set current date again
                PickerDate.date = Date()
                
                ArrDrugStringSearch.removeAll()
                ArrDrugStringSearch = ArrDrugString
                ClockAmPm = ""
                TFClock.text = ""
                TFEndDate.text = ""
                TFNumDays.text = ""
                TFStartDate.text = ""
                NewDate = ""
                TFNumDrug.text = ""
                TFDrugName.text = ""
                drugId = 0
                doseTimeId = 0
                BtnDay.isSelected = false
                BtnClock.isSelected = false
                
                CloseView_NoContent()
                ViewModel.ArrNotifications?.items?.removeAll()
                TVScreen.reloadData()
                ViewModel.maxResultCount = 10
                ViewModel.skipCount      = 0
                ViewModel.customerId     =  Helper.shared.getUser()?.id // they take it from token
                ViewAddNewNotification.isHidden = true
                self.view.endEditing(true)

                getNotifications()

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
//        if model?.active == true {
            
            cell.ViewColor.backgroundColor = UIColor(named: model?.active == true ? "bg":"FFE1E1")
            [cell.View1,cell.View2,cell.View3,cell.View4,cell.View5].forEach{$0.backgroundColor = UIColor(named: model?.active == true ? "secondary":"wrong")}
        
        cell.LaStatus.textColor = UIColor(named: model?.active == true ? "secondary":"wrong")

//            cell.View1.backgroundColor = UIColor(named: "secondary")
//            cell.View2.backgroundColor = UIColor(named: "secondary")
//            cell.View3.backgroundColor = UIColor(named: "secondary")
//            cell.View4.backgroundColor = UIColor(named: "secondary")
//            cell.View5.backgroundColor = UIColor(named: "secondary")
//            cell.LaStatus.textColor    = UIColor(named: "secondary")
            //
//            cell.ViewLine1.backgroundColor = .white
//            cell.ViewLine2.backgroundColor = .white
//            cell.ViewLine3.backgroundColor = .white
//            cell.ViewLine4.backgroundColor = .white
        [cell.ViewLine1,cell.ViewLine2,cell.ViewLine3,cell.ViewLine4].forEach{$0.backgroundColor = UIColor(named: "main")?.withAlphaComponent(0.1)}

            //
//            cell.LaTitle.textColor = .white
//            cell.LaClock.textColor = .white
//            cell.LaEvery.textColor = .white
//            cell.LaStartDate.textColor = .white
//            cell.LaEndDate.textColor = .white
//            cell.LaPeriod.textColor = .white
//            cell.LLocClock.textColor = .white
//            cell.LLocEvery.textColor = .white
//            cell.LLocStartDate.textColor = .white
//            cell.LLocEndDate.textColor = .white
//            cell.LLocPeriod.textColor = .white
            [cell.LaTitle,cell.LaClock,cell.LaEvery,cell.LaStartDate,
             cell.LaPeriod,
             cell.LLocClock,
             cell.LLocEvery,
             cell.LLocStartDate,cell.LLocEndDate,
             cell.LLocPeriod,
             cell.LaEndDate
            ].forEach{$0.textColor = UIColor(named:model?.active == true ? "main":"wrong")}

        cell.LaStatus.text = model?.active == true ? "notfication_active".localized : "notfication_inactive".localized

            cell.IVPhotoTitle.tintColor = UIColor(named:model?.active == true ? "secondary":"wrong")
            
            
            
//        } else {
//            
//            cell.ViewColor.backgroundColor = UIColor(named: "FFE1E1")
//            cell.View1.backgroundColor = UIColor(named: "wrong")
//            cell.View2.backgroundColor = UIColor(named: "wrong")
//            cell.View3.backgroundColor = UIColor(named: "wrong")
//            cell.View4.backgroundColor = UIColor(named: "wrong")
//            cell.View5.backgroundColor = UIColor(named: "wrong")
//            cell.LaStatus.textColor    = UIColor(named: "wrong")
//            //
//            cell.ViewLine1.backgroundColor = UIColor(named: "halfwrong")
//            cell.ViewLine2.backgroundColor = UIColor(named: "halfwrong")
//            cell.ViewLine3.backgroundColor = UIColor(named: "halfwrong")
//            cell.ViewLine4.backgroundColor = UIColor(named: "halfwrong")
//            //
//            cell.LaTitle.textColor = UIColor(named: "wrong")
//            cell.LaClock.textColor = UIColor(named: "wrong")
//            cell.LaEvery.textColor = UIColor(named: "wrong")
//            cell.LaStartDate.textColor = UIColor(named: "wrong")
//            cell.LaEndDate.textColor = UIColor(named: "wrong")
//            cell.LaPeriod.textColor = UIColor(named: "wrong")
//            cell.LLocClock.textColor = UIColor(named: "wrong")
//            cell.LLocEvery.textColor = UIColor(named: "wrong")
//            cell.LLocStartDate.textColor = UIColor(named: "wrong")
//            cell.LLocEndDate.textColor = UIColor(named: "wrong")
//            cell.LLocPeriod.textColor = UIColor(named: "wrong")
//            
//            cell.LaStatus.text = "مُنتهي"
//            cell.IVPhotoTitle.tintColor = UIColor(named: "wrong")
//
//        }
        print(":::::: \(model?.timeIsOver) \(model?.active)")
        cell.LaTitle.text = model?.drugTitle
        cell.LaEvery.text =  "\(model?.count ?? 0 ) \(model?.doseTimeTitle ?? "" )"
        
        if model?.days == 1 {
            cell.LaPeriod.text = "يوم"
        } else if model?.days == 2 {
            cell.LaPeriod.text = "يومين"
        }  else if model?.days == 3 || model?.days == 4 || model?.days == 4 || model?.days == 6 || model?.days == 7 || model?.days == 8 || model?.days == 9 || model?.days == 10 {
            cell.LaPeriod.text = "\(model?.days ?? 0) أيام"
        } else {
            cell.LaPeriod.text = "\(model?.days ?? 0) يوم"
        }
        
        let inputFormat = "yyyy-MM-dd'T'HH:mm:ss"
//        let outputFormat = "yyyy-MM-dd hh:mm a"
        let outputFormat = "dd/MM/yyyy"
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        
        if let inputDate = inputFormatter.date(from: (model?.startDate)!) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = outputFormat
//            outputFormatter.locale     = Locale(identifier: "en")
            let outputDateStr = outputFormatter.string(from: inputDate)
            cell.LaStartDate.text = outputDateStr
        } else {
            cell.LaStartDate.text = model?.startDate
            print("Failed to parse input date")
        }
        
        if let inputDate2 = inputFormatter.date(from: (model?.endDate)!) {
            let outputFormatter2 = DateFormatter()
            outputFormatter2.dateFormat = outputFormat
//            outputFormatter2.locale     = Locale(identifier: "en")
            let outputDateStr2 = outputFormatter2.string(from: inputDate2)
            cell.LaEndDate.text = outputDateStr2
        } else {
            cell.LaEndDate.text = model?.endDate
            print("Failed to parse input date")
        }
                
        
        if let inputDate3 = inputFormatter.date(from: (model?.startDate)!) {
            let outputFormatter3 = DateFormatter()
            outputFormatter3.dateFormat = "hh:mm a"
//            outputFormatter3.locale     = Locale(identifier: "en")
            let outputDateStr3 = outputFormatter3.string(from: inputDate3)
            cell.LaClock.text = outputDateStr3
        } else {
            cell.LaEndDate.text = model?.endDate
            print("Failed to parse input date")
        }
        

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
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == TFClock {
            return false
        } else {
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == TFDrugName {
//            drugId = 0
//            print("drugId is zero : \(drugId)")
//        }
    }
    
 
    @objc func textFieldDidChange(textField : UITextField){

        if textField == TFNumDays {
            
            if TFStartDate.text == "" {
                TFEndDate.text = ""
                TFNumDays.text = ""
                self.showAlert(message: "من فضلك ادخل تاريخ البداية")
            } else {
                if textField.text == "0" || textField.text == "" {
                    TFEndDate.text = ""
                    TFNumDays.text = ""
                    self.showAlert(message: "عدد الايام لابد ان يكون اكبر من صفر")
                } else {

                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    dateFormatter.locale     = Locale(identifier: "en_US_POSIX")

                    let date = dateFormatter.date(from: NewDate)!

                    var dateComponents = DateComponents()
                    dateComponents.day = Int(TFNumDays.text!.convertedDigitsToLocale(Locale(identifier: "EN")))

                    let calendar = Calendar.current
                    let newDate = calendar.date(byAdding: dateComponents, to: date)!
                    let newDateString = dateFormatter.string(from: newDate)
                    print("newDateString : \(newDateString)")
                    TFEndDate.text = newDateString
                }
                
            }
        }
    }
}
