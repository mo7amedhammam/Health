//
//  TipsCategoriesCVCell1.swift
//  Health
//
//  Created by Hamza on 26/08/2023.
//

import UIKit

class TipsCategoriesCVCell1: UICollectionViewCell {

    @IBOutlet weak var ImgTipCategory: UIImageView!
    @IBOutlet weak var LaTipTitle: UILabel!
    @IBOutlet weak var LaTipDisease: UILabel!
    @IBOutlet weak var LaTipDate: UILabel!
    var model:TipsNewestM?{
        didSet{
            guard let model = model else{return}
            LaTipTitle.text = model.title
            LaTipDisease.text = model.tipCategoryTitle
            LaTipDate.text = model.date?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd / MM / yyyy")
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
