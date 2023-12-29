//
//  HomeCVCell1.swift
//  Health
//
//  Created by Hamza on 01/10/2023.
//

import UIKit
import Foundation

class HomeCVCell1: UICollectionViewCell {
    @IBOutlet weak var LaTitle: UILabel!
    @IBOutlet weak var ImgMeasurement: UIImageView!
    @IBOutlet weak var LaCount: UILabel!
    @IBOutlet weak var LaDate: UILabel!
    
    
    @IBOutlet weak var SVViewDate: UIStackView!
    
    @IBOutlet weak var ViewDate: UIView!
        
    var model:ModelMyMeasurementsStats?{
        didSet{
            guard let model = model else{return}
            LaTitle.text = model.title
            LaCount.text = "\(model.lastMeasurementValue ?? "0")"
            LaDate.text = convertToStandardDateFormat(dateString: model.lastMeasurementDate ?? "")

            if LaCount.text == "0" {
                ViewDate.isHidden = true
            } else {
                ViewDate.isHidden = false
            }
            
            if let img = model.image {
                //                let processor = SVGImgProcessor() // if receive svg image
                ImgMeasurement.kf.setImage(with: URL(string:Constants.baseURL + img.validateSlashs()), placeholder: UIImage(named: "defaultLogo"), options: nil, progressBlock: nil)
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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.transform = CGAffineTransform(scaleX: -1, y: 1) // second tip for mirroring Cell content

    }

}
