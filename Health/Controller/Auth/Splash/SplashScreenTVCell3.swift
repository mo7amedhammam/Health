//
//  SplashScreenTVCell3.swift
//  Health
//
//  Created by Hamza on 28/07/2023.
//

import UIKit

class SplashScreenTVCell3: UICollectionViewCell {

    var delegate : SplashScreenTVCell_protocoal!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func BUSkip3(_ sender: Any) {
        delegate.SkipSplash()
    }

}
