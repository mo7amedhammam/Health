//
//  HomeCVCell1.swift
//  Health
//
//  Created by Hamza on 01/10/2023.
//

import UIKit

class HomeCVCell1: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.transform = CGAffineTransform(scaleX: -1, y: 1) // second tip for mirroring Cell content

    }

}
