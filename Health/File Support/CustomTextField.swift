//
//  CustomTextField.swift
//  Sehaty
//
//  Created by mohamed hammam on 07/04/2025.
//

import UIKit

@IBDesignable
class CustomTextField: UIView {
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
     let textField = UITextField()
    private let separatorView = UIView()
    private let iconImageView = UIImageView()
    private let passwordToggleButton = UIButton(type: .custom)
    
    // MARK: - Localizable Properties
    @IBInspectable var titleKey: String = "" {
        didSet {
            titleLabel.text = titleKey.localized
        }
    }
    
    @IBInspectable var placeholderKey: String = "" {
        didSet { textField.placeholder = placeholderKey.localized }
    }
    
    // MARK: - Font Properties
    @IBInspectable var titleFontName: String = "" {
        didSet { updateTitleFont() }
    }
    
    @IBInspectable var titleFontSize: CGFloat = 16 {
        didSet { updateTitleFont() }
    }
    
    @IBInspectable var textFontName: String = "" {
        didSet { updateTextFont() }
    }
    
    @IBInspectable var textFontSize: CGFloat = 12 {
        didSet { updateTextFont() }
    }
    
    // MARK: - New Properties for Character Limiting
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
        didSet { iconImageView.image = icon?.withRenderingMode(.alwaysTemplate) }
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

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupViews()
        // Dummy content
            titleLabel.text = titleKey.isEmpty ? "Title" : titleKey
            textField.placeholder = placeholderKey.isEmpty ? "Placeholder" : placeholderKey
            iconImageView.image = UIImage(systemName: "person")
    }

    // MARK: - Setup
    private func setupViews() {
        guard !didSetupViews else { return }
        didSetupViews = true

        // Title Label
        titleLabel.textAlignment = .right
        titleLabel.textColor = titleColor
        updateTitleFont()
        
        // Text Field
        textField.borderStyle = .none
        textField.textAlignment = .right
        textField.textColor = textColor
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        updateTextFont()
        
        // Icon ImageView
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = iconColor
        
        // Separator
        separatorView.backgroundColor = separatorColor
        
        // Add subviews
        addSubview(titleLabel)
        addSubview(textField)
        addSubview(separatorView)
        addSubview(iconImageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            // Text Field
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            textField.heightAnchor.constraint(equalToConstant: 40),
            
            // Icon
            iconImageView.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            // Separator
            separatorView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 2),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 2)
        ])
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
    
    // MARK: - Modified Validation Methods
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
             // Reset to default colors when empty
             titleLabel.textColor = titleColor
             textField.textColor = textColor
             separatorView.backgroundColor = separatorColor
         } else {
             // Apply validation colors only when not empty
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
        guard isPasswordField else {
            passwordToggleButton.removeFromSuperview()
            textField.isSecureTextEntry = false
            return
        }
        
        passwordToggleButton.setImage(UIImage(resource: .eyeIcon), for: .normal)
        passwordToggleButton.tintColor = iconColor
        passwordToggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        addSubview(passwordToggleButton)
        
        passwordToggleButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordToggleButton.trailingAnchor.constraint(equalTo: textField.leadingAnchor, constant: 0),
            passwordToggleButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            passwordToggleButton.widthAnchor.constraint(equalToConstant: 24),
            passwordToggleButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        textField.isSecureTextEntry = true
    }
    
    @objc private func togglePasswordVisibility() {
        textField.isSecureTextEntry.toggle()
        passwordToggleButton.setImage(UIImage(resource: .eyeIcon), for: .normal)
    }
    
    // MARK: - Public Methods
    func text() -> String? {
        return textField.text
    }
    
    func showError() {
        isValid = false
    }
    
    func hideError() {
        isValid = true
    }
    
    func validateField() -> Bool {
        validate()
        return isValid
    }
    
    // MARK: - RTL Support
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsLayout()
        
        let isRTL = LocalizationManager.shared.currentLanguage == "ar"
        
        // Adjust layout for RTL or LTR based on the language
        if isRTL {
            // Adjust for RTL
            titleLabel.textAlignment = .right
            textField.textAlignment = .right
            textField.semanticContentAttribute = .forceRightToLeft
            
            // Move icon to the right side
            NSLayoutConstraint.deactivate(iconImageView.constraints)
            iconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
            
            // Move password toggle to the left side
            if isPasswordField {
                NSLayoutConstraint.deactivate(passwordToggleButton.constraints)
                passwordToggleButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
            }
        } else {
            // Adjust for LTR (default)
            titleLabel.textAlignment = .left
            textField.textAlignment = .left
            textField.semanticContentAttribute = .forceLeftToRight
            
            // Move icon to the left side
            NSLayoutConstraint.deactivate(iconImageView.constraints)
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
            
            // Move password toggle to the right side (for LTR)
            if isPasswordField {
                NSLayoutConstraint.deactivate(passwordToggleButton.constraints)
                passwordToggleButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
            }
        }
    }


}

// MARK: - Text Field Delegate
   extension CustomTextField: UITextFieldDelegate {
       func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           guard maxCharacterCount > 0 else { return true }
           
           let currentText = textField.text ?? ""
           guard let stringRange = Range(range, in: currentText) else { return false }
           let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
           
           return updatedText.count <= maxCharacterCount
       }
   }
