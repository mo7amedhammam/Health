//
//  ProfileTVCellHeader.swift
//  Health
//
//  Created by Hamza on 03/08/2023.
//

import UIKit

class ProfileTVCellHeader: UITableViewCell {

    @IBOutlet weak var LaName: UILabel!
    @IBOutlet weak var LaPhone: UILabel!
    @IBOutlet weak var IVPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
