//
//  TipsCategoriesCVCell0.swift
//  Health
//
//  Created by Hamza on 26/08/2023.
//

import UIKit

class TipsCategoriesCVCell0: UICollectionViewCell {
    
    @IBOutlet weak var ImgTipCategory: UIImageView!
    @IBOutlet weak var LaTitleTipCategory: UILabel!
    var model:TipsAllItem?{
        didSet{
            guard let model = model else{return}
            LaTitleTipCategory.text = model.title
            if let img = model.image {
                //                let processor = SVGImgProcessor() // if receive svg image
                ImgTipCategory.kf.setImage(with: URL(string:Constants.baseURL + img.validateSlashs()), placeholder: UIImage(named: "defaultLogo"), options: nil, progressBlock: nil)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.transform = CGAffineTransform(scaleX: -1, y: 1) // second tip for mirroring Cell content
        
    }
    
}

