//
//  WillExpireTVCell.swift
//  Sehaty
//
//  Created by Hamza on 09/10/2023.
//

import UIKit

class WillExpireTVCell: UITableViewCell {

    @IBOutlet weak var LaTitle: UILabel!
    @IBOutlet weak var LaEndDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func BUMakeOrder(_ sender: Any) {
        Constants.WhatsAppNum.openWhatsApp()
    }
    
}
