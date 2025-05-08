//
//  CustomHeader.swift
//  Sehaty
//
//  Created by mohamed hammam on 08/04/2025.
//

import UIKit

@IBDesignable
class CustomHeader: UIView {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var LaTitle: UILabel!
    @IBOutlet weak var LaSubtitle: UILabel!
    
    // MARK: - Localizable Properties
    @IBInspectable var titleKey: String = "" {
        didSet {
            LaTitle.text = titleKey.localized
        }
    }
    
    @IBInspectable var subtitleKey: String = "" {
        didSet {
            LaSubtitle.text = subtitleKey.localized
        }
    }
    
    // MARK: - Title Customization
    @IBInspectable var titleColor: UIColor = .black {
        didSet { LaTitle.textColor = titleColor }
    }
    
    @IBInspectable var titleFontName: String = fontsenum.bold.rawValue {
        didSet { updateTitleFont() }
    }
    
    @IBInspectable var titleFontSize: CGFloat = 32 {
        didSet { updateTitleFont() }
    }
    
    // MARK: - Subtitle Customization
    @IBInspectable var subtitleColor: UIColor = .darkGray {
        didSet { LaSubtitle.textColor = subtitleColor }
    }
    
    @IBInspectable var subtitleFontName: String = fontsenum.medium.rawValue {
        didSet { updateSubtitleFont() }
    }
    
    @IBInspectable var subtitleFontSize: CGFloat = 16 {
        didSet { updateSubtitleFont() }
    }
    
    // MARK: - Background Customization
    @IBInspectable var headerBackgroundColor: UIColor = .clear {
        didSet { view.backgroundColor = headerBackgroundColor }
    }
    
    let nibName = "CustomHeader"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.frame = self.bounds
        addSubview(view)
        
        // Apply initial styles
        updateTitleFont()
        updateSubtitleFont()
    }
    
    private func updateTitleFont() {
        if !titleFontName.isEmpty, let font = UIFont(name: titleFontName, size: titleFontSize) {
            LaTitle.font = font
        } else {
            LaTitle.font = UIFont.systemFont(ofSize: titleFontSize, weight: .bold)
        }
    }
    
    private func updateSubtitleFont() {
        if !subtitleFontName.isEmpty, let font = UIFont(name: subtitleFontName, size: subtitleFontSize) {
            LaSubtitle.font = font
        } else {
            LaSubtitle.font = UIFont.systemFont(ofSize: subtitleFontSize, weight: .regular)
        }
    }
    
    // MARK: - RTL Support
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        let isRTL = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft
        let isRTL = LocalizationManager.shared.currentLanguage == "ar"
        LaTitle.textAlignment = isRTL ? .right : .left
        LaSubtitle.textAlignment = isRTL ? .right : .left
//        LaTitle.text = titleKey.localized
//        LaSubtitle.text = subtitleKey.localized

    }
//    override func setNeedsLayout() {
//        super.setNeedsLayout()
//
//    }
    
#if TARGET_INTERFACE_BUILDER
override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    LaTitle.text = titleKey.isEmpty ? "Preview Title" : titleKey.localized
    LaSubtitle.text = subtitleKey.isEmpty ? "Preview Subtitle" : subtitleKey.localized
}
#endif
}
