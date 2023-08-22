//
//  INBodyTVCell.swift
//  Health
//
//  Created by Hamza on 05/08/2023.
//

import UIKit

class INBodyTVCell: UITableViewCell {

    @IBOutlet weak var LaTitle: UILabel!
    
    @IBOutlet weak var IVPhoto: UIImageView!
    @IBOutlet weak var LaDate: UILabel!
    
    @IBOutlet weak var LaDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
