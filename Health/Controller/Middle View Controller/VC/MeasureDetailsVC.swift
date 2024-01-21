//
//  MeasureDetailsVC.swift
//  Sehaty
//
//  Created by Hamza on 13/01/2024.
//

import UIKit

class MeasureDetailsVC: UIViewController {
    
    @IBOutlet weak var ImgMeasurement: UIImageView!
    @IBOutlet weak var LaNum: UILabel!
    
    @IBOutlet weak var LaDateFrom: UILabel!
    @IBOutlet weak var LaDateTo: UILabel!
    
    @IBOutlet weak var BtnDay: UIButton!
    @IBOutlet weak var BtnMonth: UIButton!
    @IBOutlet weak var BtnYear: UIButton!
    @IBOutlet weak var btnAll: UIButton!
    
    
    @IBOutlet weak var LaTitle: UILabel!
    @IBOutlet weak var ViewAddMeasurement: UIView!
    @IBOutlet weak var TFNumMeasure: UITextField!
    @IBOutlet weak var TFDate: UITextField!
    @IBOutlet weak var TVDescription: TextViewWithPlaceholder!
    @IBOutlet weak var ViewSelectDate: UIView!
    @IBOutlet weak var PickerDate: UIDatePicker!
    @IBOutlet weak var ViewSecondValue: UIView!
    @IBOutlet weak var TFSecondValue: UITextField!
    
    @IBOutlet weak var ViewNoMeasurements: UIView!
    
    var imgMeasurement = ""
    var selectDateFrom = ""
    let formatter = DateFormatter()
    var ViewModel : MyMeasurementsStatsVM = MyMeasurementsStatsVM()
    var TitleMeasurement = ""
    var current = ""
    var newCreated = 0 // when back from filtter show no data or not
    var id  = 0
    var num = 0
    var formatRegex = ""
    var formatHintMessage = ""
    var measurementDate = ""
    var CellDateFrom = ""
    var CellDateTo   = ""
    var MeasurementCreated = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ImgMeasurement.kf.setImage(with: URL(string:Constants.baseURL + imgMeasurement.validateSlashs()), placeholder: UIImage(named: "defaultLogo"), options: nil, progressBlock: nil)
        
        
        TVDescription.placeholderText = "إضافة تعليق"
        PickerDate.minimumDate = nil
        PickerDate.maximumDate =  Date()
        PickerDate.datePickerMode = .dateAndTime
        PickerDate.date = Date()
        
        TFNumMeasure.keyboardType = .asciiCapable
        TFNumMeasure.delegate = self
        print("id : \(id)")
        //        if formatValue == "" || formatValue == "X" {
        //            ViewSecondValue.isHidden = true
        //        } else {
        //            ViewSecondValue.isHidden = false
        //        }
        
        // Do any additional setup after loading the view.
        //        self.PickerDate.addTarget(self, action: #selector(onDateValueChanged(_:)), for: .valueChanged)
        
        ViewSelectDate.isHidden     = true
        ViewAddMeasurement.isHidden = true
        LaTitle.text = TitleMeasurement
        ViewNoMeasurements.isHidden = true
        
        ViewModel.medicalMeasurementId = id
        getDataNormalRange()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if num == 0 {
            if newCreated == 1 {
                ViewNoMeasurements.isHidden = true
            } else {
                ViewNoMeasurements.isHidden = false
            }
        } else {
            ViewNoMeasurements.isHidden = true
        }
        
        if MeasurementCreated == true {
            num += 1
            LaNum.text = "\(num)"
            MeasurementCreated = false
            //................................
            // all
            btnAll.backgroundColor = .clear
            btnAll.setTitleColor(UIColor(named: "main") , for: .normal)
            btnAll.borderColor = UIColor(named: "main")
            
            BtnYear.backgroundColor = .clear
            BtnYear.setTitleColor( UIColor(named: "main") , for: .normal)
            BtnYear.borderColor = UIColor(named: "main")
            
            BtnMonth.backgroundColor = .clear
            BtnMonth.setTitleColor( UIColor(named: "main") , for: .normal)
            BtnMonth.borderColor = UIColor(named: "main")
            
            BtnDay.backgroundColor = .clear
            BtnDay.setTitleColor( UIColor(named: "main") , for: .normal)
            BtnDay.borderColor = UIColor(named: "main")
            
        } else {
            LaNum.text = "\(num)"
        }
        
        
    }
    
    
    func getDataNormalRange() {
        
        ViewModel.GetMeasurementNormalRange { [weak self] state in
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
            case .error(_,let error):
                Hud.dismiss(from: self.view)
                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self)
                print(error ?? "")
            case .none:
                print("")
            }
        }
    }
    
    @IBAction func BuSearch(_ sender: Any) {
        
        
        
        btnAll.backgroundColor = .clear
        btnAll.setTitleColor(UIColor(named: "main")  , for: .normal)
        btnAll.borderColor = UIColor(named: "main")
        //
        BtnYear.backgroundColor = .clear
        BtnYear.setTitleColor( UIColor(named: "main") , for: .normal)
        BtnYear.borderColor = UIColor(named: "main")
        //
        BtnMonth.backgroundColor = .clear
        BtnMonth.setTitleColor( UIColor(named: "main") , for: .normal)
        BtnMonth.borderColor = UIColor(named: "main")
        //
        BtnDay.backgroundColor = .clear
        BtnDay.setTitleColor( UIColor(named: "main") , for: .normal)
        BtnDay.borderColor = UIColor(named: "main")
        //
        BtnDay.isSelected   = false
        BtnMonth.isSelected = false
        BtnYear.isSelected  = false
        btnAll.isSelected    = false
        
        
        if LaDateFrom.text == "" {
            self.showAlert(message: "من فضلك حدد تاريخ البداية")
        } else if LaDateTo.text == "" {
            self.showAlert(message: "من فضلك حدد تاريخ النهاية")
        } else {
            
            guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: MeasurementsDetailsFiltterVC.self) else { return }
            vc.From = LaDateFrom.text!
            vc.To   = LaDateTo.text!
            vc.NormalFrom = ViewModel.ArrNormalRange?.fromValue ?? ""
            vc.NormalTo   = ViewModel.ArrNormalRange?.toValue ?? ""
            vc.TitleMeasurement = TitleMeasurement
            vc.id = id
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }
    
    
    @IBAction func BuDateFromDateTo(_ sender: UIButton){
        
        if sender.tag == 0  {
           
            PickerDate.minimumDate = nil
            PickerDate.maximumDate = Date()
            PickerDate.datePickerMode = .date
//            PickerDate.date = Date()

            if LaDateFrom.text == "" {
                PickerDate.date = Date()
            } else {
                let dd = DateFormatter()
                dd.dateFormat = "yyyy-MM-dd"
                if let date = dd.date(from: LaDateFrom.text!) {
                    PickerDate.setDate(date, animated: true)
                }
            }
            
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
                PickerDate.datePickerMode = .date
//                PickerDate.date = Date()
                
                if LaDateTo.text == "" {
                    PickerDate.date = Date()
                } else {
                    let dd = DateFormatter()
                    dd.dateFormat = "yyyy-MM-dd"
                    if let date = dd.date(from: LaDateTo.text!) {
                        PickerDate.setDate(date, animated: true)
                    }
                }
                
                ViewSelectDate.isHidden     = false
                selectDateFrom = "to"
            }
        }
    }
    
    
    @IBAction func BuAllMeasurement(_ sender: Any){
        
        
        btnAll.backgroundColor = UIColor(named: "secondary")
        btnAll.setTitleColor(.white , for: .normal)
        btnAll.borderColor = .clear
        
        BtnYear.backgroundColor = .clear
        BtnYear.setTitleColor( UIColor(named: "main") , for: .normal)
        BtnYear.borderColor = UIColor(named: "main")
        
        BtnMonth.backgroundColor = .clear
        BtnMonth.setTitleColor( UIColor(named: "main") , for: .normal)
        BtnMonth.borderColor = UIColor(named: "main")
        
        BtnDay.backgroundColor = .clear
        BtnDay.setTitleColor( UIColor(named: "main") , for: .normal)
        BtnDay.borderColor = UIColor(named: "main")
        
        
        //        ViewModel.medicalMeasurementId = id
        //        ViewModel.skipCount            = 0
        //        ViewModel.dateFrom = nil
        //        ViewModel.dateTo  = nil
        //        getDataNormalRange()
        
        BtnDay.isSelected = false
        BtnMonth.isSelected = false
        BtnYear.isSelected   = false
        
        LaDateFrom.isHidden = true
        LaDateTo.isHidden   = true
        LaDateFrom.text = ""
        LaDateTo.text   = ""
        
        CellDateFrom = ""
        CellDateTo   = ""
        current = "all"
     
        if btnAll.isSelected == false {
            btnAll.isSelected = true
            guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: MeasurementsDetailsFiltterVC.self) else { return }
            vc.From = ""
            vc.To   = ""
            vc.NormalFrom = ViewModel.ArrNormalRange?.fromValue ?? ""
            vc.NormalTo   = ViewModel.ArrNormalRange?.toValue ?? ""
            vc.TitleMeasurement = TitleMeasurement
            vc.id = id
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        } else {
            btnAll.isSelected = false

            btnAll.backgroundColor = .clear
            btnAll.setTitleColor( UIColor(named: "main") , for: .normal)
            btnAll.borderColor = UIColor(named: "main")
        }
        
    }
    
    
    
    @IBAction func BUYearMonthDay(_ sender: UIButton) {
        
        let currentDate = Date()
        let outputFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.init(localeIdentifier: "en") as Locale
        dateFormatter.dateFormat = outputFormat
        let formattedDateString = dateFormatter.string(from: currentDate)
        print("current date : \(formattedDateString)")
        
        if sender.tag == 0 { // year
            current = "year"
            BtnYear.backgroundColor = UIColor(named: "secondary")
            BtnYear.setTitleColor(.white , for: .normal)
            BtnYear.borderColor = .clear
            
            BtnMonth.backgroundColor = .clear
            BtnMonth.setTitleColor( UIColor(named: "main") , for: .normal)
            BtnMonth.borderColor = UIColor(named: "main")
            
            BtnDay.backgroundColor = .clear
            BtnDay.setTitleColor( UIColor(named: "main") , for: .normal)
            BtnDay.borderColor = UIColor(named: "main")
            
            if let currentDate = dateFormatter.date(from: formattedDateString) {
                let calendar = Calendar.current
                let sevenDaysAgo = calendar.date(byAdding: .year, value: -1, to: currentDate)
                let outputFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                dateFormatter.dateFormat = outputFormat
                let oneYear = dateFormatter.string(from: sevenDaysAgo!)
                print("oneYear : \(oneYear)")
                
                LaDateFrom.text = convertToNew(dateString: oneYear)
                LaDateTo.text   = convertToNew(dateString: formattedDateString)
                
                //                Lfrom.text = convertToStandardDateFormat__(dateString: oneYear)
                //                Lto.text   = convertToStandardDateFormat__(dateString: formattedDateString)
                
                LaDateFrom.isHidden = false
                LaDateTo.isHidden   = false
                CellDateFrom = oneYear
                CellDateTo   = formattedDateString
                
            } else {
                print("Invalid date format")
            }
            
            
        } else if sender.tag == 1 { // month
            current = "month"
            
            BtnMonth.backgroundColor = UIColor(named: "secondary")
            BtnMonth.setTitleColor(.white , for: .normal)
            BtnMonth.borderColor = .clear
            
            BtnYear.backgroundColor = .clear
            BtnYear.setTitleColor( UIColor(named: "main") , for: .normal)
            BtnYear.borderColor = UIColor(named: "main")
            
            BtnDay.backgroundColor = .clear
            BtnDay.setTitleColor( UIColor(named: "main") , for: .normal)
            BtnDay.borderColor = UIColor(named: "main")
            
            
            if let currentDate = dateFormatter.date(from: formattedDateString) {
                let calendar = Calendar.current
                let sevenDaysAgo = calendar.date(byAdding: .month, value: -3, to: currentDate)
                let outputFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                dateFormatter.dateFormat = outputFormat
                let ThreeMonth = dateFormatter.string(from: sevenDaysAgo!)
                print("ThreeMonth : \(ThreeMonth)")
                
                LaDateFrom.text = convertToNew(dateString: ThreeMonth)
                LaDateTo.text   = convertToNew(dateString: formattedDateString)
                
                //                Lfrom.text = convertToStandardDateFormat__(dateString: ThreeMonth)
                //                Lto.text   = convertToStandardDateFormat__(dateString: formattedDateString)
                
                LaDateFrom.isHidden = false
                LaDateTo.isHidden   = false
                CellDateFrom = ThreeMonth
                CellDateTo   = formattedDateString
                
                
            } else {
                print("Invalid date format")
            }
            
        } else if sender.tag == 2 { // day
            current = "day"
            
            BtnDay.backgroundColor = UIColor(named: "secondary")
            BtnDay.setTitleColor(.white , for: .normal)
            BtnDay.borderColor = .clear
            
            BtnMonth.backgroundColor = .clear
            BtnMonth.setTitleColor( UIColor(named: "main") , for: .normal)
            BtnMonth.borderColor = UIColor(named: "main")
            
            BtnYear.backgroundColor = .clear
            BtnYear.setTitleColor( UIColor(named: "main") , for: .normal)
            BtnYear.borderColor = UIColor(named: "main")
            
            
            if let currentDate = dateFormatter.date(from: formattedDateString) {
                let calendar = Calendar.current
                let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: currentDate)
                let outputFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                dateFormatter.dateFormat = outputFormat
                let sevenDaysAgoString = dateFormatter.string(from: sevenDaysAgo!)
                print("sevenDaysAgoString : \(sevenDaysAgoString)")
                
                
                LaDateFrom.text = convertToNew(dateString: sevenDaysAgoString)
                LaDateTo.text   = convertToNew(dateString: formattedDateString)
                
                //                Lfrom.text = convertToStandardDateFormat__(dateString: sevenDaysAgoString)
                //                Lto.text   = convertToStandardDateFormat__(dateString: formattedDateString)
                
                LaDateFrom.isHidden = false
                LaDateTo.isHidden   = false
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
        btnAll.isSelected = false
        
        if LaDateFrom.text == "" {
            self.showAlert(message: "من فضلك حدد تاريخ البداية")
        } else if LaDateTo.text == "" {
            self.showAlert(message: "من فضلك حدد تاريخ النهاية")
        } else {
            
            
            if sender.tag == 0 {
                
                
                if BtnYear.isSelected == false {
                    BtnYear.isSelected = true
                    
                    BtnMonth.isSelected = false
                    BtnDay.isSelected = false
                    
                    guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: MeasurementsDetailsFiltterVC.self) else { return }
                    vc.From = CellDateFrom
                    vc.To   = CellDateTo
                    vc.NormalFrom = ViewModel.ArrNormalRange?.fromValue ?? ""
                    vc.NormalTo   = ViewModel.ArrNormalRange?.toValue ?? ""
                    vc.TitleMeasurement = TitleMeasurement
                    vc.id = id
                    vc.hidesBottomBarWhenPushed = true
                    navigationController?.pushViewController(vc, animated: true)
                } else {
                    CellDateFrom = ""
                    CellDateTo   = ""
                    LaDateFrom.text     = ""
                    LaDateFrom.isHidden = true
                    LaDateTo.text     = ""
                    LaDateTo.isHidden = true
                    
                    BtnYear.isSelected  = false
                    BtnMonth.isSelected = false
                    BtnDay.isSelected   = false
                    
                    BtnYear.backgroundColor = .clear
                    BtnYear.setTitleColor( UIColor(named: "main") , for: .normal)
                    BtnYear.borderColor = UIColor(named: "main")
                }
            } else if sender.tag == 1 {
                
                if BtnMonth.isSelected == false {
                    BtnMonth.isSelected = true
                    
                    BtnYear.isSelected = false
                    BtnDay.isSelected = false
                    
                    guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: MeasurementsDetailsFiltterVC.self) else { return }
                    vc.From = CellDateFrom
                    vc.To   = CellDateTo
                    vc.NormalFrom = ViewModel.ArrNormalRange?.fromValue ?? ""
                    vc.NormalTo   = ViewModel.ArrNormalRange?.toValue ?? ""
                    vc.TitleMeasurement = TitleMeasurement
                    vc.id = id
                    vc.hidesBottomBarWhenPushed = true
                    navigationController?.pushViewController(vc, animated: true)
                } else {
                    CellDateFrom = ""
                    CellDateTo   = ""
                    LaDateFrom.text     = ""
                    LaDateFrom.isHidden = true
                    LaDateTo.text     = ""
                    LaDateTo.isHidden = true
                    
                    
                    BtnMonth.isSelected = false
                    BtnYear.isSelected = false
                    BtnDay.isSelected   = false
                    
                    BtnMonth.backgroundColor = .clear
                    BtnMonth.setTitleColor( UIColor(named: "main") , for: .normal)
                    BtnMonth.borderColor = UIColor(named: "main")
                    
                }
            } else if sender.tag == 2 {
                
                if BtnDay.isSelected == false {
                    BtnDay.isSelected   = true
                    BtnMonth.isSelected = false
                    BtnYear.isSelected  = false
                    
                    guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: MeasurementsDetailsFiltterVC.self) else { return }
                    vc.From = CellDateFrom
                    vc.To   = CellDateTo
                    vc.NormalFrom = ViewModel.ArrNormalRange?.fromValue ?? ""
                    vc.NormalTo   = ViewModel.ArrNormalRange?.toValue ?? ""
                    vc.TitleMeasurement = TitleMeasurement
                    vc.id = id
                    vc.hidesBottomBarWhenPushed = true
                    navigationController?.pushViewController(vc, animated: true)
                } else {
                    CellDateFrom = ""
                    CellDateTo   = ""
                    LaDateFrom.text     = ""
                    LaDateFrom.isHidden = true
                    LaDateTo.text     = ""
                    LaDateTo.isHidden = true
                    
                    BtnDay.isSelected = false
                    BtnMonth.isSelected = false
                    BtnYear.isSelected   = false
                    
                    BtnDay.backgroundColor = .clear
                    BtnDay.setTitleColor( UIColor(named: "main") , for: .normal)
                    BtnDay.borderColor = UIColor(named: "main")
                }
            } else {
                // nothing
            }
            
        }
        
    }
    
    
    @IBAction func BUAddNewMeasurement(_ sender: Any) {
        AddMeasurement ()
    }
    
    
    @IBAction func BUDoneSelectedDateandTime(_ sender: Any) {
        
        
        if selectDateFrom == "new" {
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
            formatter.locale     = Locale(identifier: "en")
            let strDate = formatter.string(from: PickerDate.date )
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            self.view.endEditing(true)
            print(strDate)
            
            let forma = DateFormatter()
            forma.dateFormat = "dd/MM/yyyy hh:mm a"
            forma.locale     = Locale(identifier: "en")
            let strForma = forma.string(from: PickerDate.date )
            TFDate.text = strForma
            
            measurementDate = strDate
            
        } else if selectDateFrom == "from" {
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.locale     = Locale(identifier: "en")
            let strDate = formatter.string(from: PickerDate.date )
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            self.view.endEditing(true)
            print(strDate)
            
            CellDateFrom = strDate
            LaDateFrom.text     = strDate
            LaDateFrom.isHidden = false
            current = ""
            
        } else if selectDateFrom == "to" {
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.locale     = Locale(identifier: "en")
            let strDate = formatter.string(from: PickerDate.date )
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            self.view.endEditing(true)
            print(strDate)
            
            // if select seven day then back and select date to ....to set date from with formatt
            if CellDateFrom != "" {
                CellDateFrom =  convertToNew(dateString: CellDateFrom ) ?? ""
            }
            
            CellDateTo = strDate
            LaDateTo.text     = strDate
            LaDateTo.isHidden = false
            current = ""
            
        } else {
        }
        
        ViewSelectDate.isHidden = true
    }
    
    //    @objc private func onDateValueChanged(_ datePicker: UIDatePicker) {
    //        //do something here
    //    }
    
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = NSLocale.init(localeIdentifier: "en") as Locale
        inputFormatter.dateFormat = "yyyy-MM-dd"
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
    
    
    @IBAction func BUSelectDate(_ sender: Any) {
        
        self.view.endEditing(true)
        PickerDate.minimumDate = nil
        PickerDate.maximumDate = Date()
        
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
            print("regex",formatRegex)
            print("default",formatHintMessage)
            
            // Check Format Regex here
            //            if formatValue == "" ||  formatValue == "X" {
            if let text = TFNumMeasure.text, text.matches(regex: formatRegex) {
                //            ViewModel.customerId           = Helper.getUser()?.id // they take it from token
                ViewModel.medicalMeasurementId = id
                ViewModel.value                = TFNumMeasure.text!.convertedDigitsToLocale(Locale(identifier: "EN"))
                ViewModel.comment              = TVDescription.text ?? ""
                ViewModel.measurementDate      =  convertWhenupload(dateString: measurementDate)
                CreateMeasurement ()
            } else {
                
                //                if TFSecondValue.text == "" {
                self.showAlert(message: "\(formatHintMessage)")
                //                } else {
                //                    //            ViewModel.customerId           = Helper.getUser()?.id // they take it from token
                //                    ViewModel.medicalMeasurementId = id
                //                    ViewModel.value                = "\(TFNumMeasure.text!)/\(TFSecondValue.text!)"
                //                    ViewModel.comment              = TVDescription.text ?? ""
                //                    ViewModel.measurementDate      = TFDate.text
                //                    CreateMeasurement ()
                //                }
                
            }
            
        }
        
    }
    
    
    @IBAction func BUCancelAdd(_ sender: Any) {
        measurementDate = ""
        TFDate.text      = ""
        TFNumMeasure.text = ""
        TFSecondValue.text = ""
        TVDescription.text  = ""
        TVDescription.showingPlaceholder = true
        TVDescription.showPlaceholderText()
        //        TVDescription.placeholderText = "إضافة تعليق"
        ViewAddMeasurement.isHidden = true
        self.view.endEditing(true)
    }
    
    
    
}



extension MeasureDetailsVC {
    
    
    func CreateMeasurement () {
        //check Measurement Value with Regex
        
        //send Create Request
        ViewModel.CreateMedicalMeasurements { [weak self] state in
            guard let self = self,let state = state else{
                return
            }
            switch state {
            case .loading:
                Hud.showHud(in: self.view)
            case .stopLoading:
                Hud.dismiss(from: self.view)
            case .success:
                
                Shared.shared.DateMeasurementAdded  = measurementDate
                Shared.shared.ValueMeasurementAdded = "\(TFNumMeasure.text!.convertedDigitsToLocale(Locale(identifier: "EN")))"
                Shared.shared.IsMeasurementAdded = true
                
                //to set current date again
                PickerDate.date = Date()
                
                measurementDate = ""
                TFDate.text = ""
                TFNumMeasure.text = ""
                TFSecondValue.text = ""
                TVDescription.text = ""
                MeasurementCreated = true
                ViewAddMeasurement.isHidden = true
                self.view.endEditing(true)
                
                CellDateFrom = ""
                CellDateTo = ""
                
                LaDateFrom.text     = ""
                LaDateFrom.isHidden = true
                LaDateTo.text     = ""
                LaDateTo.isHidden = true
                
                
                newCreated = 1
                
                //....
                Hud.dismiss(from: self.view)
                //......
                guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: MeasurementsDetailsFiltterVC.self) else { return }
                vc.From = ""
                vc.To   = ""
                vc.NormalFrom = self.ViewModel.ArrNormalRange?.fromValue ?? ""
                vc.NormalTo   = self.ViewModel.ArrNormalRange?.toValue ?? ""
                vc.TitleMeasurement = self.TitleMeasurement
                vc.id = self.id
                vc.new = 1
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            case .error(_,let error):
                Hud.dismiss(from: self.view)
                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self)
                print(error ?? "")
            case .none:
                print("")
            }
        }
    }
    
    
    
    func AddMeasurement() {
        
        PickerDate.date = Date()
        PickerDate.datePickerMode = .dateAndTime
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        formatter.locale     = Locale(identifier: "en")
        let strDate = formatter.string(from: PickerDate.date )
        //        formatter.dateStyle = .medium
        //        formatter.timeStyle = .none
        self.view.endEditing(true)
        print(strDate)
        
        let forma = DateFormatter()
        forma.dateFormat = "dd/MM/yyyy hh:mm a"
        forma.locale     = Locale(identifier: "en")
        let strForma = forma.string(from: PickerDate.date )
        TFDate.text = strForma
        
        measurementDate = strDate
        
        ViewAddMeasurement.isHidden = false
    }
    
    
    
    
    func convertToNew(dateString: String) -> String? {
        let possibleDateFormats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSS" ,
            "yyyy-MM-dd'T'HH:mm" ,
            "yyyy-MM-dd'T'HH:mm:ss" ,
            "yyyy-MM-dd'T'HH:mm:ss.SS" ,
            "yyyy-MM-dd'T'hh:mm:ss.SSS" ,
            "yyyy-MM-dd'T'hh:mm:ss" ,
            "yyyy-MM-dd'T'hh:mm:ss.SS" ,
            "yyyy-MM-dd'T'hh:mm:ss.SSS" ,
            "yyyy-MM-dd",
            "MM/dd/yyyy",
            "dd/MM/yyyy",
            "MM-dd-yyyy",
            "dd-MM-yyyy" ,
            "yyyy-MM-dd"
            // Add more possible date formats as needed
        ]
        
        let outputDateFormat = DateFormatter()
        outputDateFormat.dateFormat = "yyyy-MM-dd"
        
        for dateFormat in possibleDateFormats {
            let inputDateFormat = DateFormatter()
            inputDateFormat.dateFormat = dateFormat
            
            if let date = inputDateFormat.date(from: dateString) {
                let convertedDate = outputDateFormat.string(from: date)
                return convertedDate
            }
        }
        
        return dateString
    }
    
    
    func convertWhenupload(dateString: String) -> String? {
        let possibleDateFormats = [
            "dd/MM/yyyy hh:mm a" ,
        ]
        let outputDateFormat = DateFormatter()
        outputDateFormat.dateFormat = "yyyy-MM-dd hh:mm a"
        
        for dateFormat in possibleDateFormats {
            let inputDateFormat = DateFormatter()
            inputDateFormat.dateFormat = dateFormat
            
            if let date = inputDateFormat.date(from: dateString) {
                let convertedDate = outputDateFormat.string(from: date)
                return convertedDate
            }
        }
        
        return dateString
    }
    
    
    
}

extension MeasureDetailsVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == TFNumMeasure {
            // Define the allowed characters (0-9 and "/")
            let allowedCharacterSet = CharacterSet(charactersIn: "0123456789/")
            // Check if the replacement string contains only allowed characters
            let isValidInput = string.rangeOfCharacter(from: allowedCharacterSet.inverted) == nil
            // If it's a valid input, allow the change
            return isValidInput
        } else {
            return true
        }
    }
}
