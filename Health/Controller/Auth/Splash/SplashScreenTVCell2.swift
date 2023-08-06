//
//  SplashScreenTVCell2.swift
//  Health
//
//  Created by Hamza on 28/07/2023.
//

import UIKit

class SplashScreenTVCell2: UICollectionViewCell {

    var delegate : SplashScreenTVCell_protocoal!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func BUSkip2(_ sender: Any) {
        delegate.SkipSplash()
    }
}
