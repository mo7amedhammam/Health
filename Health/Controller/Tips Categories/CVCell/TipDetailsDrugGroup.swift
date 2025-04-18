//
//  TipDetailsDrugGroup.swift
//  Health
//
//  Created by wecancity on 25/09/2023.
//

import UIKit

class TipDetailsDrugGroup: UICollectionViewCell {
    @IBOutlet weak var LaDrugTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        contentView.transform = CGAffineTransform(scaleX: -1, y: 1) // second tip for mirroring Cell content
        // Make the label text underlined
//        let attributedText = NSAttributedString(string: LaDrugTitle.text ?? "",
//                                               attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
//        LaDrugTitle.attributedText = attributedText

    }

    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        // Perform your custom layout calculations here
//        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
//        var newFrame = layoutAttributes.frame
//        newFrame.size.width = CGFloat(ceilf(Float(size.width)))
//        layoutAttributes.frame = newFrame
//        return layoutAttributes
//    }
}
