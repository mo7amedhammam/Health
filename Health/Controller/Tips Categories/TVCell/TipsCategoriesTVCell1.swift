//
//  TipsCategoriesTVCell1.swift
//  Health
//
//  Created by Hamza on 27/08/2023.
//

import UIKit

class TipsCategoriesTVCell1: UITableViewCell {

    
    @IBOutlet weak var CollectionCat: UICollectionView!
    var delegate : TipsCategoriesTVCell1_protocoal!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func BUMoreFirstCollection(_ sender: Any) {
        delegate.MoreFirstCollection()
    }
    
    
    
}


protocol TipsCategoriesTVCell1_protocoal {
    func MoreFirstCollection ()
}
