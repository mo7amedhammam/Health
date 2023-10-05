//
//  ExUiButtons.swift
//  Health
//
//  Created by wecancity on 04/10/2023.
//

import UIKit
extension UIButton {
    func enable(_ isActive: Bool) {
        isEnabled = isActive
        alpha = isActive ? 1.0 : 0.5
    }
}
