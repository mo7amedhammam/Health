//
//  CustomInputField.swift
//  Sehaty
//
//  Created by mohamed hammam on 08/04/2025.
//

import UIKit
@IBDesignable
class CustomInputField: UIView {

    // MARK: - Outlets
    // MARK: - Outlets
       @IBOutlet weak var titleLabel: UILabel!
       @IBOutlet weak var contentStackView: UIStackView!
       @IBOutlet weak var textFieldStack: UIStackView!
       @IBOutlet weak var passwordToggleButton: UIButton!
       @IBOutlet weak var textField: UITextField!
       @IBOutlet weak var iconImageView: UIImageView!
       @IBOutlet weak var separatorView: UIView!
       
       // MARK: - Localizable Properties
       @IBInspectable var titleKey: String = "" {
           didSet {
               titleLabel.text = titleKey.localized
               updateTextAlignment()
           }
       }
       
       @IBInspectable var placeholderKey: String = "" {
           didSet {
               textField.placeholder = placeholderKey.localized
               updateTextAlignment()
           }
       }
       
       // MARK: - Font Properties
    @IBInspectable var titleFontName: String = fontsenum.boldEn.rawValue {
           didSet { updateTitleFont() }
       }
       
       @IBInspectable var titleFontSize: CGFloat = 16 {
           didSet { updateTitleFont() }
       }
       
    @IBInspectable var textFontName: String = fontsenum.medium.rawValue {
           didSet { updateTextFont() }
       }
       
       @IBInspectable var textFontSize: CGFloat = 12 {
           didSet { updateTextFont() }
       }
       
       // MARK: - Character Limiting
       @IBInspectable var maxCharacterCount: Int = 0 {
           didSet {
               if maxCharacterCount > 0 {
                   textField.delegate = self
               }
           }
       }
       
       // MARK: - Validation Properties
       @IBInspectable var errorColor: UIColor = .red {
           didSet { updateErrorState() }
       }
       
       private var isValid: Bool = true {
           didSet { updateErrorState() }
       }
       
       var validationRule: ((String?) -> Bool)? {
           didSet { validate() }
       }
       
       var onValidationChanged: ((Bool) -> Void)?
       
       // MARK: - Other Properties
       @IBInspectable var icon: UIImage? {
           didSet {
               iconImageView.image = icon?.withRenderingMode(.alwaysTemplate)
               updateIconVisibility()
           }
       }
       
       @IBInspectable var isPasswordField: Bool = false {
           didSet { setupPasswordToggle() }
       }
       
       @IBInspectable var separatorColor: UIColor = UIColor.lightGray {
           didSet { separatorView.backgroundColor = separatorColor }
       }
       
       @IBInspectable var textColor: UIColor = UIColor.black {
           didSet { textField.textColor = textColor }
       }
       
       @IBInspectable var titleColor: UIColor = UIColor.darkGray {
           didSet { titleLabel.textColor = titleColor }
       }
       
       @IBInspectable var iconColor: UIColor = UIColor.gray {
           didSet { iconImageView.tintColor = iconColor }
       }

       private var didSetupViews = false
    let nibName = "CustomInputField"
    @IBOutlet weak var view: UIView!

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
        setupViews()
    }
    
    
    // MARK: - Setup
       private func setupViews() {
           guard !didSetupViews else { return }
           didSetupViews = true
           
           // Title Label
           titleLabel.textColor = titleColor
           updateTitleFont()
           updateTextAlignment()
           
           // TextField
           textField.borderStyle = .none
           textField.textColor = textColor
           textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
           updateTextFont()
           updateTextAlignment()
           
           // Icon
           iconImageView.contentMode = .scaleAspectFit
           iconImageView.tintColor = iconColor
           updateIconVisibility()
           
           // Password Toggle
           passwordToggleButton.setImage(UIImage(resource: .eyeIcon), for: .normal)
           passwordToggleButton.tintColor = iconColor
           passwordToggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
           passwordToggleButton.isHidden = !isPasswordField
           
           // Separator
           separatorView.backgroundColor = separatorColor
           
           // Stack setup
           textFieldStack.axis = .horizontal
           textFieldStack.alignment = .center
           textFieldStack.distribution = .fill
           textFieldStack.spacing = 8
           
           // Content stack
           contentStackView.axis = .vertical
           contentStackView.alignment = .fill
           contentStackView.distribution = .fill
           contentStackView.spacing = 4
           
           // Layout direction handling
           updateLayoutDirection()
       }
       
       private func updateLayoutDirection() {
           let isRTL = LocalizationManager.shared.currentLanguage == "ar"
           
           // Semantic content affects stack views and image flipping
           contentStackView.semanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
           textFieldStack.semanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
           
           // Update text alignment based on language
           updateTextAlignment()
           
           // Rebuild the text field stack
           rebuildTextFieldStack()
           
       }
       
       private func rebuildTextFieldStack() {

           // Clear existing arranged subviews
           textFieldStack.arrangedSubviews.forEach {
               textFieldStack.removeArrangedSubview($0)
               $0.removeFromSuperview()
           }
           
               textFieldStack.addArrangedSubview(passwordToggleButton)
               textFieldStack.addArrangedSubview(textField)
               textFieldStack.addArrangedSubview(iconImageView)

           // Set constraints
           NSLayoutConstraint.activate([
               iconImageView.widthAnchor.constraint(equalToConstant: 24),
               passwordToggleButton.widthAnchor.constraint(equalToConstant: 24)
           ])
       }
       
    override func didMoveToWindow() {
        super.didMoveToWindow()
        updateLayoutDirection()
    }
       private func updateTextAlignment() {
           let isRTL = LocalizationManager.shared.currentLanguage == "ar"

           titleLabel.textAlignment = isRTL ? .right : .left
           textField.textAlignment = isRTL ? .right : .left
           
           // Placeholder alignment
           let placeholder = textField.placeholder ?? ""
           let paragraphStyle = NSMutableParagraphStyle()
           paragraphStyle.alignment = isRTL ? .right : .left
           
           textField.attributedPlaceholder = NSAttributedString(
               string: placeholder,
               attributes: [.paragraphStyle: paragraphStyle]
           )
       }
       
       private func updateIconVisibility() {
           iconImageView.isHidden = icon == nil
       }
       
       // MARK: - Font Methods
       private func updateTitleFont() {
           if !titleFontName.isEmpty, let font = UIFont(name: titleFontName, size: titleFontSize) {
               titleLabel.font = font
           } else {
               titleLabel.font = UIFont.systemFont(ofSize: titleFontSize)
           }
       }
       
       private func updateTextFont() {
           if !textFontName.isEmpty, let font = UIFont(name: textFontName, size: textFontSize) {
               textField.font = font
           } else {
               textField.font = UIFont.systemFont(ofSize: textFontSize)
           }
       }
       
       // MARK: - Validation Methods
       private func validate() {
           guard let rule = validationRule else { return }
           
           let isEmpty = textField.text?.isEmpty ?? true
           let newIsValid = isEmpty ? true : rule(textField.text)
           
           if newIsValid != isValid {
               isValid = newIsValid
               onValidationChanged?(isValid && !isEmpty)
           }
       }
       
       private func updateErrorState() {
           let isEmpty = textField.text?.isEmpty ?? true
           
           if isEmpty {
               titleLabel.textColor = titleColor
               textField.textColor = textColor
               separatorView.backgroundColor = separatorColor
           } else {
               let color = isValid || isEmpty ? titleColor : errorColor
               titleLabel.textColor = color
               textField.textColor = isValid || isEmpty ? textColor : errorColor
               separatorView.backgroundColor = isValid || isEmpty ? separatorColor : errorColor
           }
       }
       
       @objc private func textFieldDidChange() {
           validate()
       }
       
       // MARK: - Password Toggle
       private func setupPasswordToggle() {
           textField.isSecureTextEntry = isPasswordField
           passwordToggleButton.isHidden = !isPasswordField
       }
       
       @objc private func togglePasswordVisibility() {
           textField.isSecureTextEntry.toggle()
           let iconName = textField.isSecureTextEntry ? UIImage(resource: .eyeIcon) : UIImage(resource: .eyeIcn)
           passwordToggleButton.setImage(iconName, for: .normal)
       }
   }

   // MARK: - Text Field Delegate
   extension CustomInputField: UITextFieldDelegate {
       func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           guard maxCharacterCount > 0 else { return true }
           
           let currentText = textField.text ?? ""
           guard let stringRange = Range(range, in: currentText) else { return false }
           let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
           
           return updatedText.count <= maxCharacterCount
       }
   }
