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
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var ViewAddMeasurement: UIView!
    @IBOutlet weak var TFNumMeasure: UITextField!
    @IBOutlet weak var TFDate: UITextField!
    @IBOutlet weak var TVDescription: TextViewWithPlaceholder!
    @IBOutlet weak var ViewSelectDate: UIView!
    @IBOutlet weak var PickerDate: UIDatePicker!
    @IBOutlet weak var ViewSecondValue: UIView!
    @IBOutlet weak var TFSecondValue: UITextField!
    
    @IBOutlet weak var ViewNoMeasurements: UIView!
    
    
    var current = ""
    var newCreated = 0 // when back from filtter show no data or not
    var id  = 0
    var num = 0
    var TitleMeasurement = ""
    var imgMeasurement = ""
    // to fill lable in cell0
    var CellDateFrom = ""
    var CellDateTo   = ""
    //    var formatValue = ""
    var formatRegex = ""
    var formatHintMessage = ""
    var MeasurementCreated = false
    //
    var selectDateFrom = ""
    let formatter = DateFormatter()
    var ViewModel : MyMeasurementsStatsVM = MyMeasurementsStatsVM()
    var measurementDate = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        TVScreen.dataSource = self
        TVScreen.delegate   = self
        TVScreen.registerCellNib(cellClass: MeasurementsDetailsTVCell.self)
        TVScreen.registerCellNib(cellClass: MeasurementsDetailsTVCell0.self)
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
//        current = ""
//        CellDateFrom = ""
//        CellDateTo   = ""
//        TVScreen.reloadData()
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
            forma.dateFormat = "yyyy-MM-dd hh:mm a"
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
            current = ""
            TVScreen.reloadData()
        } else if selectDateFrom == "to" {
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.locale     = Locale(identifier: "en")
            let strDate = formatter.string(from: PickerDate.date )
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            self.view.endEditing(true)
            print(strDate)
            
            CellDateTo = strDate
            current = ""
            TVScreen.reloadData()
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
   
        self.view.endEditing(true)
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
                ViewModel.measurementDate      = measurementDate
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


extension MeasurementsDetailsVC {
    
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
                TVScreen.reloadData()
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
                
                Shared.shared.DateMeasurementAdded = measurementDate
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
                TVScreen.reloadData()
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
}

extension MeasurementsDetailsVC : UITableViewDataSource , UITableViewDelegate , MeasurementsDetailsTVCell0_Protocoal {
    
    func FromDateToDate(select: String  , LaDateFrom : UILabel) {
        
        if select == "from" {
            PickerDate.minimumDate = nil
            PickerDate.maximumDate = Date()
            PickerDate.datePickerMode = .date
            PickerDate.date = Date()

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
                PickerDate.date = Date()
                
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
        
        
        //        ViewModel.medicalMeasurementId = id
        //        ViewModel.skipCount            = 0
        //        ViewModel.dateFrom = nil
        //        ViewModel.dateTo  = nil
        //        getDataNormalRange()
        
        btnDay.isSelected = false
        btnMonth.isSelected = false
        btnYear.isSelected   = false
        
        CellDateFrom = ""
        CellDateTo   = ""
        current = "all"
        TVScreen.reloadData()
     
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
    
    func TearMonthDay(tag: Int , btnAll : UIButton , btnYear : UIButton , btnMonth : UIButton  , btnDay : UIButton , Lfrom : UILabel , Lto : UILabel  ) {
        
        let currentDate = Date()
        let outputFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.init(localeIdentifier: "en") as Locale
        dateFormatter.dateFormat = outputFormat
        let formattedDateString = dateFormatter.string(from: currentDate)
        print("current date : \(formattedDateString)")
        
        if tag == 0 { // year
            current = "year"
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
                let outputFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                dateFormatter.dateFormat = outputFormat
                let oneYear = dateFormatter.string(from: sevenDaysAgo!)
                print("oneYear : \(oneYear)")
                
                
                
                Lfrom.text = convertToStandardDateFormat__(dateString: oneYear)
                Lto.text   = convertToStandardDateFormat__(dateString: formattedDateString)
                
                Lfrom.isHidden = false
                Lto.isHidden   = false
                CellDateFrom = oneYear
                CellDateTo   = formattedDateString
                
            } else {
                print("Invalid date format")
            }
            
            
        } else if tag == 1 { // month
            current = "month"

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
                let outputFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                dateFormatter.dateFormat = outputFormat
                let ThreeMonth = dateFormatter.string(from: sevenDaysAgo!)
                print("ThreeMonth : \(ThreeMonth)")
                
                Lfrom.text = convertToStandardDateFormat__(dateString: ThreeMonth)
                Lto.text   = convertToStandardDateFormat__(dateString: formattedDateString)
                
                Lfrom.isHidden = false
                Lto.isHidden   = false
                CellDateFrom = ThreeMonth
                CellDateTo   = formattedDateString
                
                
            } else {
                print("Invalid date format")
            }
            
        } else if tag == 2 { // day
            current = "day"

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
                let outputFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                dateFormatter.dateFormat = outputFormat
                let sevenDaysAgoString = dateFormatter.string(from: sevenDaysAgo!)
                print("sevenDaysAgoString : \(sevenDaysAgoString)")
                
                Lfrom.text = convertToStandardDateFormat__(dateString: sevenDaysAgoString)
                Lto.text   = convertToStandardDateFormat__(dateString: formattedDateString)
                
                Lfrom.isHidden = false
                Lto.isHidden   = false
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
        
        if Lfrom.text == "" {
            self.showAlert(message: "من فضلك حدد تاريخ البداية")
        } else if Lto.text == "" {
            self.showAlert(message: "من فضلك حدد تاريخ النهاية")
        } else {
            
//            TVScreen.reloadData()
            
            if tag == 0 {
          
                
                if btnYear.isSelected == false {
                    btnYear.isSelected = true

                    btnMonth.isSelected = false
                    btnDay.isSelected = false

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
                    TVScreen.reloadData()

                    btnYear.isSelected  = false
                    btnMonth.isSelected = false
                    btnDay.isSelected   = false

                    btnYear.backgroundColor = .clear
                    btnYear.setTitleColor( UIColor(named: "main") , for: .normal)
                    btnYear.borderColor = UIColor(named: "main")
                }
            } else if tag == 1 {

                if btnMonth.isSelected == false {
                    btnMonth.isSelected = true

                    btnYear.isSelected = false
                    btnDay.isSelected = false

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
                    TVScreen.reloadData()

                    btnMonth.isSelected = false
                    btnYear.isSelected = false
                    btnDay.isSelected   = false

                    btnMonth.backgroundColor = .clear
                    btnMonth.setTitleColor( UIColor(named: "main") , for: .normal)
                    btnMonth.borderColor = UIColor(named: "main")

                }
            } else if tag == 2 {
              
                if btnDay.isSelected == false {
                    btnDay.isSelected   = true
                    btnMonth.isSelected = false
                    btnYear.isSelected  = false

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
                    TVScreen.reloadData()

                    btnDay.isSelected = false
                    btnMonth.isSelected = false
                    btnYear.isSelected   = false

                    btnDay.backgroundColor = .clear
                    btnDay.setTitleColor( UIColor(named: "main") , for: .normal)
                    btnDay.borderColor = UIColor(named: "main")
                }
            } else {
                // nothing
            }
            
        }
        
    }
    
    func Search(Lfrom : UILabel , Lto : UILabel , btnAl : UIButton , btnYear : UIButton ,  btnMonth : UIButton ,  btnDay : UIButton ) {
        
        btnAl.backgroundColor = .clear
        btnAl.setTitleColor(UIColor(named: "main")  , for: .normal)
        btnAl.borderColor = UIColor(named: "main")
        //
        btnYear.backgroundColor = .clear
        btnYear.setTitleColor( UIColor(named: "main") , for: .normal)
        btnYear.borderColor = UIColor(named: "main")
        //
        btnMonth.backgroundColor = .clear
        btnMonth.setTitleColor( UIColor(named: "main") , for: .normal)
        btnMonth.borderColor = UIColor(named: "main")
        //
        btnDay.backgroundColor = .clear
        btnDay.setTitleColor( UIColor(named: "main") , for: .normal)
        btnDay.borderColor = UIColor(named: "main")
        //
        btnDay.isSelected   = false
        btnMonth.isSelected = false
        btnYear.isSelected  = false
        btnAl.isSelected    = false
        
        
        if Lfrom.text == "" {
            self.showAlert(message: "من فضلك حدد تاريخ البداية")
        } else if Lto.text == "" {
            self.showAlert(message: "من فضلك حدد تاريخ النهاية")
        } else {
            
            guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: MeasurementsDetailsFiltterVC.self) else { return }
            vc.From = Lfrom.text!
            vc.To   = Lto.text!
            vc.NormalFrom = ViewModel.ArrNormalRange?.fromValue ?? ""
            vc.NormalTo   = ViewModel.ArrNormalRange?.toValue ?? ""
            vc.TitleMeasurement = TitleMeasurement
            vc.id = id
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            
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
        forma.dateFormat = "yyyy-MM-dd hh:mm a"
        forma.locale     = Locale(identifier: "en")
        let strForma = forma.string(from: PickerDate.date )
        TFDate.text = strForma
        
        measurementDate = strDate
        
        ViewAddMeasurement.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeasurementsDetailsTVCell0", for: indexPath) as! MeasurementsDetailsTVCell0
        cell.delegate = self
        //                let processor = SVGImgProcessor() // if receive svg image
        cell.ImgMeasurement.kf.setImage(with: URL(string:Constants.baseURL + imgMeasurement.validateSlashs()), placeholder: UIImage(named: "defaultLogo"), options: nil, progressBlock: nil)
        
        
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
        if let range = ViewModel.ArrNormalRange {
            cell.LaNaturalFrom.text = "من : \(range.fromValue ?? "" )"
            cell.LaNaturalTo.text   = "الي : \(range.toValue ?? "" )"
        }
        if MeasurementCreated == true {
            num += 1
            cell.LaNum.text = "\(num)"
            MeasurementCreated = false
            //................................
            // all
            cell.btnAll.backgroundColor = .clear
            cell.btnAll.setTitleColor(UIColor(named: "main") , for: .normal)
            cell.btnAll.borderColor = UIColor(named: "main")
            
            cell.BtnYear.backgroundColor = .clear
            cell.BtnYear.setTitleColor( UIColor(named: "main") , for: .normal)
            cell.BtnYear.borderColor = UIColor(named: "main")
            
            cell.BtnMonth.backgroundColor = .clear
            cell.BtnMonth.setTitleColor( UIColor(named: "main") , for: .normal)
            cell.BtnMonth.borderColor = UIColor(named: "main")
            
            cell.BtnDay.backgroundColor = .clear
            cell.BtnDay.setTitleColor( UIColor(named: "main") , for: .normal)
            cell.BtnDay.borderColor = UIColor(named: "main")
            
        } else {
            cell.LaNum.text = "\(num)"
        }
        
        if current == "" {
            cell.btnAll.backgroundColor = .clear
            cell.btnAll.setTitleColor(UIColor(named: "main") , for: .normal)
            cell.btnAll.borderColor = UIColor(named: "main")
            
            cell.BtnYear.backgroundColor = .clear
            cell.BtnYear.setTitleColor( UIColor(named: "main") , for: .normal)
            cell.BtnYear.borderColor = UIColor(named: "main")
            
            cell.BtnMonth.backgroundColor = .clear
            cell.BtnMonth.setTitleColor( UIColor(named: "main") , for: .normal)
            cell.BtnMonth.borderColor = UIColor(named: "main")
            
            cell.BtnDay.backgroundColor = .clear
            cell.BtnDay.setTitleColor( UIColor(named: "main") , for: .normal)
            cell.BtnDay.borderColor = UIColor(named: "main")
        }
       
        return cell
        
    }
    
}


extension MeasurementsDetailsVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == TFNumMeasure {
            let allowedCharacters = CharacterSet(charactersIn: "0123456789/-")
            let filteredString = string.components(separatedBy: allowedCharacters.inverted).joined(separator: "")
            return string == filteredString
        } else {
            return true
        }
    }
}
