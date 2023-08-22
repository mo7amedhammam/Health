//
//  MedicationScheduleTVCell.swift
//  Health
//
//  Created by Hamza on 06/08/2023.
//

import UIKit

class MedicationScheduleTVCell: UITableViewCell {

    @IBOutlet weak var LaTitle: UILabel!
    @IBOutlet weak var LaNum: UILabel!
    @IBOutlet weak var LaStartDate: UILabel!
    @IBOutlet weak var LaEndDate: UILabel!
    @IBOutlet weak var LaTimeNext: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
