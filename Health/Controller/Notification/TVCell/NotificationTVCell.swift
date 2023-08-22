//
//  NotificationTVCell.swift
//  Health
//
//  Created by Hamza on 23/08/2023.
//

import UIKit

class NotificationTVCell: UITableViewCell {

    @IBOutlet weak var IVPhotoTitle: UIImageView!
    
    @IBOutlet weak var LaTitle: UILabel!
    
    @IBOutlet weak var ViewColor: UIView!
    
    @IBOutlet weak var LLocStartDate: UILabel!
    @IBOutlet weak var LLocClock: UILabel!
    @IBOutlet weak var LLocEvery: UILabel!
    @IBOutlet weak var LLocPeriod: UILabel!
    @IBOutlet weak var LLocEndDate: UILabel!
    
    @IBOutlet weak var LaStartDate: UILabel!
    @IBOutlet weak var LaClock: UILabel!
    @IBOutlet weak var LaEvery: UILabel!
    @IBOutlet weak var LaPeriod: UILabel!
    @IBOutlet weak var LaEndDate: UILabel!
    @IBOutlet weak var LaStatus: UILabel!

    @IBOutlet weak var View1: UIView!
    @IBOutlet weak var View2: UIView!
    @IBOutlet weak var View3: UIView!
    @IBOutlet weak var View4: UIView!
    @IBOutlet weak var View5: UIView!

    @IBOutlet weak var ViewLine1: UIView!
    @IBOutlet weak var ViewLine2: UIView!
    @IBOutlet weak var ViewLine3: UIView!
    @IBOutlet weak var ViewLine4: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
