//
//  HomeCVCell2.swift
//  Health
//
//  Created by Hamza on 01/10/2023.
//

import UIKit

class HomeCVCell2: UICollectionViewCell {
    @IBOutlet weak var LaTitle: UILabel!
    
    @IBOutlet weak var LaEndDate: UILabel!
    var model : PrescriptionM?{
        didSet{
            guard let model = model else{return}
            LaTitle.text = model.drugTitle
//            LaEndDate.text = model.endDate?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "yyyy/MM/dd")
            LaEndDate.text = convertToStandardDateFormat(dateString:  model.endDate ?? "")
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
    
//    var makeOrder:(()->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.transform = CGAffineTransform(scaleX: -1, y: 1) // second tip for mirroring Cell content

    }

    @IBAction func BtnMakeOrder(_ sender: Any) {
//        makeOrder?()
        Constants.WhatsAppNum.openWhatsApp()
    }
    
}
