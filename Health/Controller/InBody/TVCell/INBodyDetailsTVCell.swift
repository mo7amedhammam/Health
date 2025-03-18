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
    var inbodyitemModel : InbodyListItemM? {
        didSet{
            guard let model = inbodyitemModel else {return}
            LaTitle.text = model.customerName
            if let date =  Helper.shared.ChangeFormate(NewFormat: "yyyy-MM-dd'T'HH:mm:ss").date(from: model.date ?? ""){
                LaTime.text = Helper.shared.ChangeFormate(NewFormat: "dd/MM/yyyy  hh:mm a").string(from: date )
            }

            if model.comment == "" || model.comment == nil {
                LaDescrip.text = "لا توجد ملاحظات"
            } else {
                LaDescrip.setJustifiedRight(model.comment)
                LaDescrip.setLineHeight(lineHeight: 2)
                
                if isArabic(model.comment ?? "") == true {
                    LaDescrip.textAlignment = .right
                } else {
                    LaDescrip.textAlignment = .left
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
    
    
    @IBAction func BUDownloadReport(_ sender: Any) {
        delegae.DownloadReport()
    }
    
    
    
}


protocol INBodyDetailsTVCell_protocoal {
    
    func DownloadReport ()
}
