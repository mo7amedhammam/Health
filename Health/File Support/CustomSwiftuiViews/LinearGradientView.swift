//
//  LinearGradientView.swift
//  Sehaty
//
//  Created by mohamed hammam on 15/06/2025.
//

import SwiftUI

struct HorizontalGradientBackground: ViewModifier {
    var colors: [Color] = [.mainBlue, Color(.secondary)]
    var reverse: Bool = false

    func body(content: Content) -> some View {
//        let finalColors = (Helper.shared.getLanguage().lowercased() != "ar") || reverse ? colors : colors.reversed()
        let finalColors =  !reverse ? colors.reversed() : colors

        content
            .background(
                LinearGradient(
                    gradient: Gradient(colors: finalColors),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            
//            .localizeView()
//            .reversLocalizeView()
    }
}
extension View {
    func horizontalGradientBackground(colors: [Color] = [.mainBlue, Color(.secondary)],reverse: Bool = false) -> some View {
        self.modifier(HorizontalGradientBackground(colors: colors,reverse: reverse))
    }
}


//MARK: -- for UIKIT ----
import UIKit

func applyHorizontalGradient(to button: UIButton, colors: [UIColor] = [UIColor(Color(.mainBlue)), UIColor(Color(.secondary))]) {
    // Remove old gradient layers if any
    button.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })

    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = colors.map { $0.cgColor }
    gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
    gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
    gradientLayer.frame = button.bounds
    gradientLayer.cornerRadius = button.layer.cornerRadius

    button.layer.insertSublayer(gradientLayer, below: button.titleLabel?.layer)
//    button.setTitleColor(.white, for: .normal)
    button.clipsToBounds = true
}

//class GradientBackgroundView: UIView {
//    var colors: [UIColor] = [UIColor(Color(.mainBlue)) , UIColor(Color(.secondary))] {
//        didSet {
//            updateGradient()
//        }
//    }
//    
//    private let gradientLayer = CAGradientLayer()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupGradient()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupGradient()
//    }
//    
//    private func setupGradient() {
//        gradientLayer.colors = colors.map { $0.cgColor }
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
//        layer.insertSublayer(gradientLayer, at: 0)
//    }
//    
//    private func updateGradient() {
//        gradientLayer.colors = colors.map { $0.cgColor }
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        gradientLayer.frame = bounds
//    }
//}

//class GradientView: UIView {
//    var colors: [UIColor] = [UIColor(Color.mainBlue), UIColor(Color.secondary)] {
//        didSet { updateGradient() }
//    }
//    
//    private let gradientLayer = CAGradientLayer()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setup()
//    }
//    
//    private func setup() {
//        layer.insertSublayer(gradientLayer, at: 0)
//        updateGradient()
//    }
//    
//    private func updateGradient() {
//        gradientLayer.colors = colors.map { $0.cgColor }
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        gradientLayer.frame = bounds
//    }
//}

//extension UIView {
//    func applyHorizontalGradient(colors: [UIColor] = [UIColor(Color.mainBlue), UIColor(Color.secondary)]) {
//        // Remove previous gradients
//        layer.sublayers?
//            .filter { $0.name == "HorizontalGradient" }
//            .forEach { $0.removeFromSuperlayer() }
//        
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.name = "HorizontalGradient"
//        gradientLayer.colors = colors.map { $0.cgColor }
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
//        gradientLayer.frame = bounds
//        layer.insertSublayer(gradientLayer, at: 0)
//        
//        // Observe bounds changes
//        let observer = self.observe(\.bounds, options: [.new]) { [weak self] (_, _) in
//            DispatchQueue.main.async {
//                self?.layer.sublayers?
//                    .filter { $0.name == "HorizontalGradient" }
//                    .forEach { $0.frame = self?.bounds ?? .zero }
//            }
//        }
//        
//        // Store observer
//        objc_setAssociatedObject(self, "gradientObserver", observer, .OBJC_ASSOCIATION_RETAIN)
//    }
//}

