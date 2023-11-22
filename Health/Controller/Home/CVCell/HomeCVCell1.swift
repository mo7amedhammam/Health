//
//  HomeCVCell1.swift
//  Health
//
//  Created by Hamza on 01/10/2023.
//

import UIKit

class HomeCVCell1: UICollectionViewCell {
    @IBOutlet weak var LaTitle: UILabel!
    
    @IBOutlet weak var ImgMeasurement: UIImageView!
    
    @IBOutlet weak var LaCount: UILabel!
    @IBOutlet weak var LaDate: UILabel!
    var model:ModelMyMeasurementsStats?{
        didSet{
            guard let model = model else{return}
            LaTitle.text = model.title
            LaCount.text = "\(model.lastMeasurementValue ?? "")"
            LaDate.text = model.lastMeasurementDate?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "yyyy/MM/dd")

            if let img = model.image {
                //                let processor = SVGImgProcessor() // if receive svg image
                ImgMeasurement.kf.setImage(with: URL(string:Constants.baseURL + img.validateSlashs()), placeholder: UIImage(named: "defaultLogo"), options: nil, progressBlock: nil)
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.transform = CGAffineTransform(scaleX: -1, y: 1) // second tip for mirroring Cell content

    }

}
