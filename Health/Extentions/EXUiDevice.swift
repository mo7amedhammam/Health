//
//  EXUiDevice.swift
//  Health
//
//  Created by wecancity on 21/09/2023.
//

import UIKit

extension UIDevice {
    var hasNotch: Bool
    {
        if #available(iOS 11.0, *)
        {
            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            return bottom > 0
        } else
        {
            // Fallback on earlier versions
            return false
        }
    }
}
