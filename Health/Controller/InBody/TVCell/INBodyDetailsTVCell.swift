//
//  INBodyDetailsTVCell.swift
//  Health
//
//  Created by Hamza on 05/08/2023.
//

import UIKit

class INBodyDetailsTVCell: UITableViewCell {

    
    @IBOutlet weak var IVPhoto: UIImageView!
    
    @IBOutlet weak var LaTitle: UILabel!
    @IBOutlet weak var LaTime: UILabel!
    @IBOutlet weak var LaDescrip: UILabel!

    var delegae : INBodyDetailsTVCell_protocoal!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func BUDownloadReport(_ sender: Any) {
        delegae.DownloadReport()
    }
    
    
    
}


protocol INBodyDetailsTVCell_protocoal {
    
    func DownloadReport ()
}
