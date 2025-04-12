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
