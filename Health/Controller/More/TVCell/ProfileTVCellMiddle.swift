//
//  ProfileTVCellMiddle.swift
//  Health
//
//  Created by Hamza on 03/08/2023.
//

import UIKit

class ProfileTVCellMiddle: UITableViewCell {

    @IBOutlet weak var ViewColor: UIView!
    
    @IBOutlet weak var LaTitle: UILabel!
    @IBOutlet weak var IVPhoto: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        LaTitle.font = UIFont(name: fontsenum.bold.rawValue, size: 13)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}

extension ProfileTVCellMiddle {
//    func configure(with item: ProfileVC.MenuItem, isSelected: Bool) {
//        LaTitle.text = item.title
//        IVPhoto.image = UIImage(named: item.imageName)?.withRenderingMode(.alwaysTemplate)
//        ViewColor.backgroundColor = isSelected ? UIColor(named: "secondary") : .clear
//    }
}
