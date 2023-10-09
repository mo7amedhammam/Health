//
//  HomeCVCell2.swift
//  Health
//
//  Created by Hamza on 01/10/2023.
//

import UIKit

class HomeCVCell2: UICollectionViewCell {
    @IBOutlet weak var LaTitle: UILabel!
    
    @IBOutlet weak var LaEndDate: UILabel!
    var model : PrescriptionM?{
        didSet{
            guard let model = model else{return}
            LaTitle.text = model.drugTitle
            LaEndDate.text = model.endDate?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd/MM/yyyy")
        }
    }
//    var makeOrder:(()->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.transform = CGAffineTransform(scaleX: -1, y: 1) // second tip for mirroring Cell content

    }

    @IBAction func BtnMakeOrder(_ sender: Any) {
//        makeOrder?()
        Constants.WhatsAppNum.openWhatsApp()
    }
    
}
