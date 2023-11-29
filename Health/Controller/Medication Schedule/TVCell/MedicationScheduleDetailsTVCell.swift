//
//  MedicationScheduleDetailsTVCell.swift
//  Health
//
//  Created by Hamza on 06/08/2023.
//

import UIKit

class MedicationScheduleDetailsTVCell: UITableViewCell {

    @IBOutlet weak var ViewBackground: UIView!
    @IBOutlet weak var ImgDrugIcon: UIImageView!
    @IBOutlet weak var LaTitle: UILabel!
    @IBOutlet weak var LaStartDate: UILabel!
    @IBOutlet weak var LaClock: UILabel!
    @IBOutlet weak var LaEvery: UILabel!
    @IBOutlet weak var LaPeriod: UILabel!
    @IBOutlet weak var LaEndDate: UILabel!
    @IBOutlet weak var LaStatus: UILabel!
    @IBOutlet weak var LaDescription: UILabel!
    @IBOutlet weak var DescribtionView: UIView!
    @IBOutlet var LaText: [UILabel]!
    
    @IBOutlet var DotsViews: [UIView]!
    
    let inactiveTextColor       = UIColor(named: "wrong")
    let inactiveBackgroundColor = UIColor(red: 1, green: 0.88, blue: 0.88, alpha: 1)
    
    
    var DrugModel : MedicationScheduleDrugM?{
        didSet{
            guard let model = DrugModel else{return}
            LaTitle.text = model.drugTitle
            
            LaStartDate.text = convertToStandardDateFormat(dateString : model.startDate ?? "" )
            //LaClock.text = model.startDate?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "hh:mm a")
            LaClock.text = convertStringDateToTime(dateString : model.startDate ?? ""  )
            
            LaEvery.text = "\(model.count ?? 0) \(model.doseTimeTitle ?? "")"
            LaPeriod.text = "\(model.days ?? 0) أيام"
            
            //LaEndDate.text = model.endDate?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "yyyy/MM/dd")
            LaEndDate.text = convertToStandardDateFormat(dateString : model.endDate ?? "" )

            LaDescription.text = model.pharmacistComment
            LaStatus.text = model.active ?? false ? "فعّال":"مًنتهى"
            
            setactivColors(isactive: model.active ?? true)
            
            if model.active == true {
                LaDescription.textColor = UIColor(named: "main")
            } else {
                LaDescription.textColor = UIColor(named: "wrong")
            }
        }
    }
    
    
    func convertToStandardDateFormat(dateString: String) -> String? {
        let possibleDateFormats = [
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
            "dd-MM-yyyy"
            // Add more possible date formats as needed
        ]

        let outputDateFormat = DateFormatter()
        outputDateFormat.dateFormat = "yyyy/MM/dd"

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
    
    
    
    func convertStringDateToTime(dateString: String) -> String? {
        let possibleDateFormats = [
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
            "dd-MM-yyyy"
            // Add more possible date formats as needed
        ]

        let outputDateFormat = DateFormatter()
        outputDateFormat.dateFormat = "hh:mm a"

        for dateFormat in possibleDateFormats {
            let inputDateFormat = DateFormatter()
            inputDateFormat.dateFormat = dateFormat

            if let date = inputDateFormat.date(from: dateString) {
                let convertedDate = outputDateFormat.string(from: date)
                return convertedDate
            }
        }

        return ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension MedicationScheduleDetailsTVCell{
    func setactivColors(isactive : Bool){
        if isactive == false {
            ImgDrugIcon.image = UIImage(named: "inactivedrugicon")
            ViewBackground.backgroundColor  = inactiveBackgroundColor
            DescribtionView.backgroundColor = .white.withAlphaComponent(0.4)
            LaText.forEach { label in
                label.textColor = inactiveTextColor
            }
            DotsViews.forEach { dotV in
                dotV.backgroundColor = inactiveTextColor
            }
        } else {
            
            ImgDrugIcon.image = UIImage(named: "Medical Notification-01 3")
            ViewBackground.backgroundColor  = UIColor(named: "main")
            DescribtionView.backgroundColor = .white
            LaText.forEach { label in
                label.textColor = .white
            }
            DotsViews.forEach { dotV in
                dotV.backgroundColor =  UIColor(named: "second")
            }
        }
    }
}
