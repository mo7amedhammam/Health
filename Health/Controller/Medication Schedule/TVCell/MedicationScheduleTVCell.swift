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
    var SchedualModel : MedicationScheduleItem?{
        didSet{
            guard let model = SchedualModel else{return}
            LaTitle.text = model.title
            LaNum.text = "\(model.drugsCount ?? 0)"
            if let startDate =  Helper.ChangeFormate(NewFormat: "yyyy-MM-dd'T'HH:mm:ss").date(from: model.startDate ?? ""){
                LaStartDate.text = Helper.ChangeFormate(NewFormat: "dd/MM/yyyy").string(from: startDate )
            }
            if let endDate =  Helper.ChangeFormate(NewFormat: "yyyy-MM-dd'T'HH:mm:ss").date(from: model.endDate ?? ""){
                LaEndDate.text = Helper.ChangeFormate(NewFormat: "dd/MM/yyyy").string(from: endDate )
            }
            if let renewDate =  Helper.ChangeFormate(NewFormat: "yyyy-MM-dd'T'HH:mm:ss").date(from: model.renewDate ?? ""){
                LaTimeNext.text = Helper.ChangeFormate(NewFormat: "dd/MM/yyyy hh:mm a").string(from: renewDate )
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
