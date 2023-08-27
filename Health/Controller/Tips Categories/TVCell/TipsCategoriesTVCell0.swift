//
//  TipsCategoriesTVCell0.swift
//  Health
//
//  Created by Hamza on 26/08/2023.
//

import UIKit

class TipsCategoriesTVCell0: UITableViewCell {

    @IBOutlet weak var CollectionTips: UICollectionView!
    var delegate : TipsCategoriesTVCell0_protocoal!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func BUMore(_ sender: Any) {
        delegate.MoreCell()
    }
    
    
    
}

protocol TipsCategoriesTVCell0_protocoal {
    func MoreCell ()
}
