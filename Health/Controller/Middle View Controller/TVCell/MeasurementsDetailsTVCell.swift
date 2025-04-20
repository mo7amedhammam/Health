//
//  MeasurementsDetailsTVCell.swift
//  Health
//
//  Created by Hamza on 08/08/2023.
//

import UIKit

class MeasurementsDetailsTVCell: UITableViewCell {

    @IBOutlet weak var ViewColor: UIView!
    @IBOutlet weak var LaDate: UILabel!
    @IBOutlet weak var LaNum: UILabel!
    @IBOutlet weak var LaDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        LaDate.reverselocalizedview()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
