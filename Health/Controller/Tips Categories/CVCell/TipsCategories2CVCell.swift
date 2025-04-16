//
//  TipsCategories2CVCell.swift
//  Health
//
//  Created by Hamza on 26/08/2023.
//

import UIKit

struct secondVCTipM {
    var image,title,date:String?
    var id,subjectsCount:Int?
}
class TipsCategories2CVCell: UICollectionViewCell {

    @IBOutlet weak var ImgTipCategory: UIImageView!
    @IBOutlet weak var LaTitle: UILabel!
    @IBOutlet weak var LaCount: UILabel!

    var type = ""
    var model: secondVCTipM?{
        
        didSet{
            guard let model = model else{return}
            LaTitle.text = model.title
            
            if type == "all" {
                LaCount.text = "\(model.subjectsCount ?? 0) مواضيع"
            } else {
                LaCount.text  = convertDateToString(inputDateString: model.date ?? ""  , inputDateFormat: "yyyy-MM-dd'T'HH:mm:ss", outputDateFormat: "yyyy-MM-dd")
            }
            
            if let img = model.image {
                //                let processor = SVGImgProcessor() // if receive svg image
                ImgTipCategory.kf.setImage(with: URL(string:Constants.imagesURL + img.validateSlashs()), placeholder: UIImage(named: "defaultLogo"), options: nil, progressBlock: nil)
            }

        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.transform = CGAffineTransform(scaleX: -1, y: 1) //first tip mirror effect for x -> second in cell

    }

}
