//
//  ExUiButtons.swift
//  Health
//
//  Created by wecancity on 04/10/2023.
//

import UIKit
extension UIButton {
    func isEnabled(_ isActive: Bool) {
        isEnabled = isActive
        backgroundColor = isActive ? UIColor(.mainBlue) : UIColor(resource: .btnDisabledBg)
        titleLabel?.textColor = isActive ? .white : UIColor(resource: .btnDisabledTxt)
//        alpha = isActive ? 1.0 : 0.5
    }
    
    func underlineCurrentTitle() {
           guard let currentTitle = self.title(for: .normal),
                 let currentFont = self.titleLabel?.font,
                 let currentColor = self.titleColor(for: .normal) else { return }

           let attributedString = NSAttributedString(
               string: currentTitle,
               attributes: [
                   .underlineStyle: NSUnderlineStyle.single.rawValue,
                   .font: currentFont,
                   .foregroundColor: currentColor
               ]
           )

           self.setAttributedTitle(attributedString, for: .normal)
       }
}
