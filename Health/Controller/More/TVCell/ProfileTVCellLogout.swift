//
//  ProfileTVCellLogout.swift
//  Health
//
//  Created by Hamza on 03/08/2023.
//

import UIKit

class ProfileTVCellLogout: UITableViewCell {

    
    @IBOutlet weak var LaTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        LaTitle.font = UIFont(name: fontsenum.bold.rawValue, size: 14)
        LaTitle.text = Helper.shared.CheckIfLoggedIn() ? "تسجيل الخروج".localized : "تسجيل الدخول".localized
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
