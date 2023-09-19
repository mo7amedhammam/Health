//
//  TipsCategories2CVCell.swift
//  Health
//
//  Created by Hamza on 26/08/2023.
//

import UIKit

struct secondVCTipM {
    var image,title:String?
    var id,subjectsCount:Int?
}
class TipsCategories2CVCell: UICollectionViewCell {

    @IBOutlet weak var ImgTipCategory: UIImageView!
    @IBOutlet weak var LaTitle: UILabel!
    @IBOutlet weak var LaCount: UILabel!
    
    var model: secondVCTipM?{
        didSet{
            guard let model = model else{return}
            LaTitle.text = model.title
            LaCount.text = "\(model.subjectsCount ?? 0) مواضيع"
            if let img = model.image {
                //                let processor = SVGImgProcessor() // if receive svg image
                ImgTipCategory.kf.setImage(with: URL(string:Constants.baseURL + img.validateSlashs()), placeholder: UIImage(named: "person"), options: nil, progressBlock: nil)
            }

        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.transform = CGAffineTransform(scaleX: -1, y: 1) //first tip mirror effect for x -> second in cell

    }

}
