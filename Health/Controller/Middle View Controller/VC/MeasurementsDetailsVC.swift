//
//  MeasurementsDetailsVC.swift
//  Health
//
//  Created by Hamza on 08/08/2023.
//

import UIKit

class MeasurementsDetailsVC: UIViewController {
    
    @IBOutlet weak var LaTitle: UILabel!
    @IBOutlet weak var TVScreen: UITableView!
    @IBOutlet weak var ViewAddMeasurement: UIView!
    @IBOutlet weak var TFNumMeasure: UITextField!
    @IBOutlet weak var TFDate: UITextField!
    @IBOutlet weak var TVDescription: TextViewWithPlaceholder!
    @IBOutlet weak var ViewSelectDate: UIView!
    @IBOutlet weak var PickerDate: UIDatePicker!
    
    var id  = 0
    var num = 0
    var TitleMeasurement = ""
    // to fill lable in cell0
    var CellDateFrom = ""
    var CellDateTo   = ""
    //
    var selectDateFrom = ""
    let formatter = DateFormatter()
    
    let ViewModel = MyMeasurementsStatsVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.PickerDate.addTarget(self, action: #selector(onDateValueChanged(_:)), for: .valueChanged)
        TVScreen.dataSource = self
        TVScreen.delegate   = self
        TVScreen.registerCellNib(cellClass: MeasurementsDetailsTVCell.self)
        TVScreen.registerCellNib(cellClass: MeasurementsDetailsTVCell0.self)
        //        TVScreen.reloadData()
        ViewSelectDate.isHidden     = true
        ViewAddMeasurement.isHidden = true
        
        LaTitle.text = TitleMeasurement
        ViewModel.medicalMeasurementId = id
        ViewModel.maxResultCount = 10
        ViewModel.skipCount      = 0
        ViewModel.dateFrom = nil
        ViewModel.dateTo   = nil
        getDataNormalRange()
        
    }
    
    
    
    @objc private func onDateValueChanged(_ datePicker: UIDatePicker) {
        //do something here
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
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
        //        self.dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func BuNotification(_ sender: Any) {
        
    }
    
    @IBAction func BUSelectDate(_ sender: Any) {
        
        PickerDate.minimumDate = nil
        PickerDate.maximumDate =  Date()
        
        selectDateFrom = "new"
        ViewSelectDate.isHidden = false
    }
    @IBAction func BUCancelSelectDate(_ sender: Any) {
        selectDateFrom = ""
        ViewSelectDate.isHidden = true
    }
    
    @IBAction func BUConfirmAdd(_ sender: Any) {
        
        if TFNumMeasure.text == "" {
            self.showAlert(message: "من فضلك أدخل القياس")
        } else if TFDate.text == "" {
            self.showAlert(message: "من فضلك أدخل التاريخ")
        } else {
            
            //            ViewModel.customerId           = Helper.getUser()?.id // they take it from token
            ViewModel.medicalMeasurementId = id
            ViewModel.value                = TFNumMeasure.text
            ViewModel.comment              = TVDescription.text ?? ""
            ViewModel.measurementDate      = TFDate.text
            CreateMeasurement ()
        }
        
    }
    
    @IBAction func BUCancelAdd(_ sender: Any) {
        ViewAddMeasurement.isHidden = true
    }
    
    
}


extension MeasurementsDetailsVC {
    
    func getDataNormalRange() {
        ViewModel.GetMeasurementNormalRange { [self] state in
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
                getDataMeasurement()
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
    
    func getDataMeasurement() {
        ViewModel.ArrMeasurement = nil
        ViewModel.GetMyMedicalMeasurements { [self] state in
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
                if ViewModel.ArrMeasurement?.measurements?.items != [] {
                    TVScreen.reloadData()
                }
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
    
    
    func CreateMeasurement () {
        
        ViewModel.CreateMedicalMeasurements { [self] state in
            guard let state = state else{
                return
            }
            switch state {
            case .loading:
                Hud.showHud(in: self.view)
            case .stopLoading:
                Hud.dismiss(from: self.view)
            case .success:
                
                ViewAddMeasurement.isHidden = true
                Hud.dismiss(from: self.view)
                SimpleAlert.shared.showAlert(title: "تم تسجيل قياس جديد"  ,message: "", viewController: self)
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

extension MeasurementsDetailsVC : UITableViewDataSource , UITableViewDelegate , MeasurementsDetailsTVCell0_Protocoal {
    
    
    
    func FromDateToDate(select: String  , LaDateFrom : UILabel) {
        
        if select == "from" {
            PickerDate.minimumDate = nil
            PickerDate.maximumDate = Date()
            
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
//                PickerDate.maximumDate    = Calendar.current.date(byAdding: .year, value: 10, to: Date())
                PickerDate.maximumDate    = Date()
                
                ViewSelectDate.isHidden     = false
                selectDateFrom = "to"
            }
        }
    }
    
    func AllMeasurement(btnAll : UIButton , btnYear : UIButton , btnMonth : UIButton  , btnDay : UIButton) {
        
        
        btnAll.backgroundColor = UIColor(named: "secondary")
        btnAll.setTitleColor(.white , for: .normal)
        btnAll.borderColor = .clear
        
        btnYear.backgroundColor = .clear
        btnYear.setTitleColor( UIColor(named: "main") , for: .normal)
        btnYear.borderColor = UIColor(named: "main")
        
        btnMonth.backgroundColor = .clear
        btnMonth.setTitleColor( UIColor(named: "main") , for: .normal)
        btnMonth.borderColor = UIColor(named: "main")
        
        btnDay.backgroundColor = .clear
        btnDay.setTitleColor( UIColor(named: "main") , for: .normal)
        btnDay.borderColor = UIColor(named: "main")
        
        
        ViewModel.medicalMeasurementId = id
        ViewModel.maxResultCount       = 10
        ViewModel.skipCount            = 0
        ViewModel.dateFrom = nil
        ViewModel.dateTo  = nil
        getDataNormalRange()
        
    }
    
    func TearMonthDay(tag: Int , btnAll : UIButton , btnYear : UIButton , btnMonth : UIButton  , btnDay : UIButton , Lfrom : UILabel , Lto : UILabel  ) {
        
        let currentDate = Date()
        let outputFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.init(localeIdentifier: "en") as Locale
        dateFormatter.dateFormat = outputFormat
        let formattedDateString = dateFormatter.string(from: currentDate)
        print("current date : \(formattedDateString)")
        
        
        
        if tag == 0 { // year
            btnYear.backgroundColor = UIColor(named: "secondary")
            btnYear.setTitleColor(.white , for: .normal)
            btnYear.borderColor = .clear
            
            btnMonth.backgroundColor = .clear
            btnMonth.setTitleColor( UIColor(named: "main") , for: .normal)
            btnMonth.borderColor = UIColor(named: "main")
            
            btnDay.backgroundColor = .clear
            btnDay.setTitleColor( UIColor(named: "main") , for: .normal)
            btnDay.borderColor = UIColor(named: "main")
            
            if let currentDate = dateFormatter.date(from: formattedDateString) {
                let calendar = Calendar.current
                let sevenDaysAgo = calendar.date(byAdding: .year, value: -1, to: currentDate)
                let outputFormat = "yyyy-MM-dd'T'HH:mm:ss"
                dateFormatter.dateFormat = outputFormat
                let oneYear = dateFormatter.string(from: sevenDaysAgo!)
                print("oneYear : \(oneYear)")
                
                Lfrom.text = oneYear
                Lto.text   = formattedDateString
                
                CellDateFrom = oneYear
                CellDateTo   = formattedDateString
                
            } else {
                print("Invalid date format")
            }
            
            
        } else if tag == 1 { // month
            
            btnMonth.backgroundColor = UIColor(named: "secondary")
            btnMonth.setTitleColor(.white , for: .normal)
            btnMonth.borderColor = .clear
            
            btnYear.backgroundColor = .clear
            btnYear.setTitleColor( UIColor(named: "main") , for: .normal)
            btnYear.borderColor = UIColor(named: "main")
            
            btnDay.backgroundColor = .clear
            btnDay.setTitleColor( UIColor(named: "main") , for: .normal)
            btnDay.borderColor = UIColor(named: "main")
            
            
            if let currentDate = dateFormatter.date(from: formattedDateString) {
                let calendar = Calendar.current
                let sevenDaysAgo = calendar.date(byAdding: .month, value: -3, to: currentDate)
                let outputFormat = "yyyy-MM-dd'T'HH:mm:ss"
                dateFormatter.dateFormat = outputFormat
                let ThreeMonth = dateFormatter.string(from: sevenDaysAgo!)
                print("ThreeMonth : \(ThreeMonth)")
                
                Lfrom.text = ThreeMonth
                Lto.text   = formattedDateString
                
                CellDateFrom = ThreeMonth
                CellDateTo   = formattedDateString
                
                
            } else {
                print("Invalid date format")
            }
            
            
            
        } else if tag == 2 { // day
            
            btnDay.backgroundColor = UIColor(named: "secondary")
            btnDay.setTitleColor(.white , for: .normal)
            btnDay.borderColor = .clear
            
            btnMonth.backgroundColor = .clear
            btnMonth.setTitleColor( UIColor(named: "main") , for: .normal)
            btnMonth.borderColor = UIColor(named: "main")
            
            btnYear.backgroundColor = .clear
            btnYear.setTitleColor( UIColor(named: "main") , for: .normal)
            btnYear.borderColor = UIColor(named: "main")
            
            
            if let currentDate = dateFormatter.date(from: formattedDateString) {
                let calendar = Calendar.current
                let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: currentDate)
                let outputFormat = "yyyy-MM-dd'T'HH:mm:ss"
                dateFormatter.dateFormat = outputFormat
                let sevenDaysAgoString = dateFormatter.string(from: sevenDaysAgo!)
                print("sevenDaysAgoString : \(sevenDaysAgoString)")
                
                Lfrom.text = sevenDaysAgoString
                Lto.text   = formattedDateString
                
                CellDateFrom = sevenDaysAgoString
                CellDateTo   = formattedDateString
                
                
            } else {
                print("Invalid date format")
            }
            
            
            
        } else {
            //nothing
        }
        
        btnAll.backgroundColor = .clear
        btnAll.setTitleColor( UIColor(named: "main") , for: .normal)
        btnAll.borderColor = UIColor(named: "main")
        
        if Lfrom.text == "" {
            self.showAlert(message: "من فضلك حدد تاريخ البداية")
        } else if Lto.text == "" {
            self.showAlert(message: "من فضلك حدد تاريخ النهاية")
        } else {
            
            ViewModel.medicalMeasurementId = id
            ViewModel.maxResultCount       = 10
            ViewModel.skipCount            = 0
            ViewModel.dateFrom = Lfrom.text
            ViewModel.dateTo   = Lto.text
            getDataNormalRange()
        }
        
    }
    
    func Search(Lfrom : UILabel , Lto : UILabel) {
        if Lfrom.text == "" {
            self.showAlert(message: "من فضلك حدد تاريخ البداية")
        } else if Lto.text == "" {
            self.showAlert(message: "من فضلك حدد تاريخ النهاية")
        } else {
            
            ViewModel.medicalMeasurementId = id
            ViewModel.maxResultCount       = 10
            ViewModel.skipCount            = 0
            ViewModel.dateFrom = Lfrom.text
            ViewModel.dateTo   = Lto.text
            getDataNormalRange()
        }
        
    }
    
    func AddMeasurement() {
        ViewAddMeasurement.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewModel.ArrMeasurement?.measurements?.items?.count ?? 0  + 1
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
            
            cell.LaNaturalFrom.text = "من : \(ViewModel.ArrNormalRange?.fromValue ?? "" )"
            cell.LaNaturalTo.text   = "الي : \(ViewModel.ArrNormalRange?.toValue ?? "" )"
            cell.LaNum.text = "\(num)"
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeasurementsDetailsTVCell", for: indexPath) as! MeasurementsDetailsTVCell
            
            if let model = ViewModel.ArrMeasurement?.measurements?.items?[indexPath.row] {
                cell.LaNum.text = model.value
                cell.LaDate.text = model.date
                
                if model.inNormalRang == true {
                    cell.ViewColor.backgroundColor = UIColor(named: "06AD2B")
                    cell.LaNum.textColor           = UIColor(named: "06AD2B")
                    cell.LaDescription.textColor = UIColor(named: "deactive")
                } else {
                    cell.ViewColor.backgroundColor = UIColor(named: "EE2E3A")
                    cell.LaNum.textColor           = UIColor(named: "EE2E3A")
                    cell.LaDescription.textColor = UIColor(named: "main")
                }
                
                if model.comment == nil {
                    cell.LaDescription.text = "لا يوجد تعليق"
                } else {
                    cell.LaDescription.text = model.comment
                }
            }
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (ViewModel.ArrMeasurement?.measurements?.items?.count ?? 0) - 1 {
            // Check if the last cell is about to be displayed
            if let totalCount = ViewModel.ArrMeasurement?.measurements?.totalCount, let itemsCount = ViewModel.ArrMeasurement?.measurements?.items?.count, itemsCount < totalCount {
                // Load the next page if there are more items to fetch
                loadNextPage()
            }
        }
    }
    func loadNextPage() {
//        guard (ViewModel.responseModel?.totalCount ?? 0) > (ViewModel.responseModel?.items?.count ?? 0) , ViewModel.cansearch == true else {return}
        ViewModel.skipCount = ViewModel.ArrMeasurement?.measurements?.items?.count
        getDataMeasurement()
    }
}
