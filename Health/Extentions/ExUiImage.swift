//
//  ExUiImage.swift
//  Sehaty
//
//  Created by mohamed hammam on 12/04/2025.
//

import UIKit
extension UIImage {
    var flippedIfRTL: UIImage {
        return Helper.shared.getLanguage() == "ar"
            ? self.imageFlippedForRightToLeftLayoutDirection()
            : self
    }
}

extension UIImageView{
    func makeRounded() {
            layer.borderWidth = 1
            layer.masksToBounds = false
            layer.borderColor = UIColor.black.cgColor
            layer.cornerRadius = self.frame.height / 2
            clipsToBounds = true
        }
}

