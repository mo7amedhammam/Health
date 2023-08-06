//
//  SplashScreenTVCell1.swift
//  Health
//
//  Created by Hamza on 28/07/2023.
//

import UIKit

class SplashScreenTVCell1: UICollectionViewCell {

    var delegate : SplashScreenTVCell_protocoal!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func BUSkip1(_ sender: Any) {
        delegate.SkipSplash()
    }
}

protocol SplashScreenTVCell_protocoal {
    func SkipSplash ()
}
