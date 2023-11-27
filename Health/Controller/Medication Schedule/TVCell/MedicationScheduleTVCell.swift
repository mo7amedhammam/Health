//
//  MedicationScheduleTVCell.swift
//  Health
//
//  Created by Hamza on 06/08/2023.
//

import UIKit

class MedicationScheduleTVCell: UITableViewCell {

    @IBOutlet weak var LaTitle: UILabel!
    @IBOutlet weak var LaNum: UILabel!
    @IBOutlet weak var LaStartDate: UILabel!
    @IBOutlet weak var LaEndDate: UILabel!
    @IBOutlet weak var LaTimeNext: UILabel!
    var SchedualModel : MedicationScheduleItem?{
        didSet{
            
            guard let model = SchedualModel else{return}
            LaTitle.text = model.title
            LaNum.text = "\(model.drugsCount ?? 0)"
            
            LaStartDate.text = convertToStandardDateFormat(dateString: model.startDate ?? "")
            LaEndDate.text = convertToStandardDateFormat(dateString: model.endDate ?? "")
            LaTimeNext.text = convertToStandardDateFormat(dateString: model.renewDate ?? "")

            
//            if let startDate =  Helper.ChangeFormate(NewFormat: "yyyy-MM-dd'T'HH:mm:ss").date(from: model.startDate ?? ""){
//                LaStartDate.text = Helper.ChangeFormate(NewFormat: "yyyy/MM/dd").string(from: startDate )
//            }
//            if let endDate =  Helper.ChangeFormate(NewFormat: "yyyy-MM-dd'T'HH:mm:ss").date(from: model.endDate ?? ""){
//                LaEndDate.text = Helper.ChangeFormate(NewFormat: "yyyy/MM/dd").string(from: endDate )
//            }
//            if let renewDate =  Helper.ChangeFormate(NewFormat: "yyyy-MM-dd'T'HH:mm:ss").date(from: model.renewDate ?? ""){
//                LaTimeNext.text = Helper.ChangeFormate(NewFormat: "yyyy/MM/dd hh:mm a").string(from: renewDate )
//            }

        }
    }
    
    
    func convertToStandardDateFormat(dateString: String) -> String? {
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
