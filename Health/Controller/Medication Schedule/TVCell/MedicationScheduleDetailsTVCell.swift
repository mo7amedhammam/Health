//
//  MedicationScheduleDetailsTVCell.swift
//  Health
//
//  Created by Hamza on 06/08/2023.
//

import UIKit

class MedicationScheduleDetailsTVCell: UITableViewCell {

    @IBOutlet weak var LaTitle: UILabel!
    @IBOutlet weak var LaStartDate: UILabel!
    @IBOutlet weak var LaClock: UILabel!
    @IBOutlet weak var LaEvery: UILabel!
    @IBOutlet weak var LaPeriod: UILabel!
    @IBOutlet weak var LaEndDate: UILabel!
    @IBOutlet weak var LaStatus: UILabel!
    @IBOutlet weak var LaDescription: UILabel!
    
    var DrugModel : MedicationScheduleDrugM?{
        didSet{
            guard let model = DrugModel else{return}
            LaTitle.text = model.drugTitle
            if let startDate =  Helper.ChangeFormate(NewFormat: "yyyy-MM-dd'T'HH:mm:ss").date(from: model.startDate ?? ""){
                LaStartDate.text = Helper.ChangeFormate(NewFormat: "dd/MM/yyyy").string(from: startDate )
                LaClock.text = Helper.ChangeFormate(NewFormat: "hh:mm a").string(from: startDate )
            }
            LaEvery.text = "\(model.count ?? 0) \(model.doseTimeTitle ?? "")"
            LaPeriod.text = "\(model.days ?? 0) أيام"
            
            if let endDate =  Helper.ChangeFormate(NewFormat: "yyyy-MM-dd'T'HH:mm:ss").date(from: model.endDate ?? ""){
                LaEndDate.text = Helper.ChangeFormate(NewFormat: "dd/MM/yyyy").string(from: endDate )
            }
            LaDescription.text = model.pharmacistComment
            LaStatus.text = model.active ?? false ? "منتهى":"فعال"
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
