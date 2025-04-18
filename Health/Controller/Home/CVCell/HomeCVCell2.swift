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
            LaEndDate.text = convertToStandardDateFormat(dateString:  model.endDate ?? "")
            if isArabic(model.drugTitle ?? "") == true {
                LaTitle.textAlignment = .right
            } else {
                LaTitle.textAlignment = .left
            }
            
        }
    }
    
    func isArabic(_ text: String) -> Bool {
        let arabicRange = NSRange(location: 0, length: text.utf16.count)
        let arabicPattern = "[\u{0600}-\u{06FF}\u{0750}-\u{077F}\u{08A0}-\u{08FF}\u{FB50}-\u{FDFF}\u{FE70}-\u{FEFF}\u{10E60}-\u{10E7F}\u{1EE00}-\u{1EEFF}]"
        
        if let regex = try? NSRegularExpression(pattern: arabicPattern, options: []),
           regex.firstMatch(in: text, options: [], range: arabicRange) != nil {
            return true
        }
        
        return false
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
        outputDateFormat.dateFormat = "dd/MM/yyyy"

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
//        contentView.transform = CGAffineTransform(scaleX: -1, y: 1) // second tip for mirroring Cell content

    }

    @IBAction func BtnMakeOrder(_ sender: Any) {
//        makeOrder?()
        Constants.WhatsAppNum.openWhatsApp()
    }
    
}
