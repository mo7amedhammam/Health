//
//  TipsCategories3TVCell.swift
//  Health
//
//  Created by Hamza on 26/08/2023.
//

import UIKit

class TipsCategories3TVCell: UITableViewCell {

    @IBOutlet weak var ImgTipCategory: UIImageView!
    @IBOutlet weak var LaTitle: UILabel!
    @IBOutlet weak var LaDAte: UILabel!

    var model : TipsNewestM?{
        didSet{
            guard let model = model else {return}
            LaTitle.text = model.title
            LaDAte.text = model.date?.CangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd / MM / yyyy hh:mm a")
            if let img = model.image {
                //                let processor = SVGImgProcessor() // if receive svg image
                ImgTipCategory.kf.setImage(with: URL(string:Constants.baseURL + img.validateSlashs()), placeholder: UIImage(named: "person"), options: nil, progressBlock: nil)
            }

        }
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
