//
//  CardView.swift
//  Memoria
//
//  Created by mac on 22/04/2021.
//

import UIKit
import AVFoundation


@IBDesignable
class CardView: UIView {
        
    var CornerRadius : CGFloat = 12
    var ofsetWidth : CGFloat = 0
    var ofsethHight : CGFloat = 0
    var ofsethShadowOpacity : Float = 0.6
    var mycolour = UIColor.black

    override func layoutSubviews() {
        layer.cornerRadius = self.CornerRadius
        layer.shadowColor = self.mycolour.cgColor
        layer.shadowOffset  = CGSize(width: self.ofsetWidth, height: self.ofsethHight)
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            layer.shadowOpacity = self.ofsethShadowOpacity

    }
    
}


@IBDesignable
class customCardView: UIView {

    @IBInspectable override var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.shadowRadius = newValue
            layer.masksToBounds = false
        }
    }

    @IBInspectable override var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
            layer.shadowColor = UIColor.darkGray.cgColor
        }
    }

    @IBInspectable override var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
            layer.shadowColor = UIColor.black.cgColor
            layer.masksToBounds = false
        }
    }

}
