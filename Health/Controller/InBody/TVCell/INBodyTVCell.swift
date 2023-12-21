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
    
    var inbodyitemModel : InbodyListItemM? {
        didSet{
            
            guard let model = inbodyitemModel else {return}
            LaTitle.text = model.customerName
            if let date =  Helper.ChangeFormate(NewFormat: "yyyy-MM-dd'T'HH:mm:ss").date(from: model.date ?? ""){
                LaDate.text = Helper.ChangeFormate(NewFormat: "dd/MM/yyyy  hh:mm a").string(from: date )
            }            
            if model.comment == "" || model.comment == nil {
                LaDescription.text = "لا توجد ملاحظات"
                LaDescription.textAlignment = .right
            } else {
                LaDescription.setJustifiedRight(model.comment)
                LaDescription.setLineHeight(lineHeight: 2)
                
                if isArabic(model.comment ?? "") == true {
                    LaDescription.textAlignment = .right
                } else {
                    LaDescription.textAlignment = .left
                }
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
