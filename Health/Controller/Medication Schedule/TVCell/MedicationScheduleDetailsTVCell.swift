//
//  MedicationScheduleDetailsTVCell.swift
//  Health
//
//  Created by Hamza on 06/08/2023.
//

import UIKit

class MedicationScheduleDetailsTVCell: UITableViewCell {

    @IBOutlet weak var ViewBackground: UIView!
    @IBOutlet weak var ImgDrugIcon: UIImageView!
    @IBOutlet weak var LaTitle: UILabel!
    @IBOutlet weak var LaStartDate: UILabel!
    @IBOutlet weak var LaClock: UILabel!
    @IBOutlet weak var LaEvery: UILabel!
    @IBOutlet weak var LaPeriod: UILabel!
    @IBOutlet weak var LaEndDate: UILabel!
    @IBOutlet weak var LaStatus: UILabel!
    @IBOutlet weak var LaDescription: UILabel!
    @IBOutlet weak var DescribtionView: UIView!
    @IBOutlet var LaText: [UILabel]!
    
    @IBOutlet var DotsViews: [UIView]!
    
    let inactiveTextColor = UIColor(named: "wrong")
    let inactiveBackgroundColor = UIColor(red: 1, green: 0.88, blue: 0.88, alpha: 1)
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
            LaStatus.text = model.active ?? false ? "فعّال":"مًنتهى"
            
            setactivColors(isactive: model.active ?? true)
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

extension MedicationScheduleDetailsTVCell{
    func setactivColors(isactive : Bool){
        if isactive == false {
            ImgDrugIcon.image = UIImage(named: "inactivedrugicon")

            ViewBackground.backgroundColor = inactiveBackgroundColor
            DescribtionView.backgroundColor = .white.withAlphaComponent(0.4)
            
            LaText.forEach { label in
                label.textColor = inactiveTextColor
            }
            DotsViews.forEach { dotV in
                dotV.backgroundColor = inactiveTextColor
            }
        }
    }
}
