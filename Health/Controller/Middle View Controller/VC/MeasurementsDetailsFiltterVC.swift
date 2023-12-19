//
//  MeasurementsDetailsFiltterVC.swift
//  Sehaty
//
//  Created by Hamza on 22/11/2023.
//

import UIKit

class MeasurementsDetailsFiltterVC: UIViewController {
    
    @IBOutlet weak var LaTitleBare: UILabel!
    @IBOutlet weak var TVScreen: UITableView!
    @IBOutlet weak var LaFrom: UILabel!
    @IBOutlet weak var LaTo: UILabel!
    var TitleMeasurement = ""

    var NormalFrom = ""
    var NormalTo   = ""
    var new  = 0
    var From = ""
    var To   = ""
    var id   = 0
    var ViewModel = MyMeasurementsStatsVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TVScreen.dataSource = self
        TVScreen.delegate   = self
        TVScreen.registerCellNib(cellClass: MeasurementsDetailsTVCell.self)
        
        print("from ::: \(From) to : \(To)")
        
        LaFrom.text = "من : \(NormalFrom)"
        LaTo.text   = "الي : \(NormalTo)"
        LaTitleBare.text = TitleMeasurement

        if From != "" && To != "" {
            // date from to
            ViewModel.medicalMeasurementId = id
            ViewModel.skipCount = 0
            ViewModel.dateFrom = From
            ViewModel.dateTo   = To
        } else {
            // all
            ViewModel.medicalMeasurementId = id
            ViewModel.skipCount            = 0
            ViewModel.dateFrom = nil
            ViewModel.dateTo  = nil
        }
        
        getDataMeasurement()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if new == 1 {
            SimpleAlert.shared.showAlert(title: "تم تسجيل قياس جديد"  ,message: "", viewController: self)
        }
    }

    
    @IBAction func BUBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    func getDataMeasurement() {
        ViewModel.GetMyMedicalMeasurements { [weak self] state in
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
                
                Hud.dismiss(from: self.view)
                if ViewModel.ArrMeasurement?.measurements?.items?.count != 0 {
                    TVScreen.reloadData()
                } else {
                    LoadView_NoContent(Superview: TVScreen, title: "لا توجد قياسات متاحة", img: "")
                }
                print(state)
            case .error(_,let error):
                TVScreen.reloadData()
                Hud.dismiss(from: self.view)
                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self)
                print(error ?? "")
            case .none:
                print("")
            }
        }
    }
    
}


extension MeasurementsDetailsFiltterVC : UITableViewDataSource , UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ViewModel.ArrMeasurement?.measurements?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeasurementsDetailsTVCell", for: indexPath) as! MeasurementsDetailsTVCell
        
        print("indexPath.row : \(indexPath.row)")
        
        
        let model = ViewModel.ArrMeasurement?.measurements?.items?[indexPath.row]
        
        cell.LaNum.text = model?.value
        //            cell.LaDate.text = model?.date
        
        //            let inputDateStr = "2023-11-20T20:48:00"
        let inputFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let outputFormat = "dd/MM/yyyy hh:mm a"
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        
        if let inputDate = inputFormatter.date(from: (model?.date)!) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = outputFormat
//            outputFormatter.locale     = Locale(identifier: "en")
            let outputDateStr = outputFormatter.string(from: inputDate)
            print(outputDateStr)
            cell.LaDate.text = outputDateStr
            
        } else {
            cell.LaDate.text = model?.date
            print("Failed to parse input date")
        }
        
        
        if model?.inNormalRang == true {
            cell.ViewColor.backgroundColor = UIColor(named: "06AD2B")
            cell.LaNum.textColor           = UIColor(named: "06AD2B")
        } else {
            cell.ViewColor.backgroundColor = UIColor(named: "EE2E3A")
            cell.LaNum.textColor           = UIColor(named: "EE2E3A")
        }
        
        if model?.comment == nil || model?.comment == "" {
            cell.LaDescription.text = "لا يوجد تعليق"
            cell.LaDescription.textColor = UIColor(named: "deactive")
        } else {
            cell.LaDescription.text = model?.comment
            cell.LaDescription.textColor = UIColor(named: "main")
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (ViewModel.ArrMeasurement?.measurements?.items?.count ?? 0) - 1  {
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





