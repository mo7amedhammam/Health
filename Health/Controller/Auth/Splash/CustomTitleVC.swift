//
//  CustomTitleVC.swift
//  Sehaty
//
//  Created by mohamed hammam on 08/04/2025.
//

import UIKit

@IBDesignable
class CustomTitleVC:UIView{
    
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

    
    @IBOutlet weak var view: UIView!
    
    let nibName = "CustomTitleVC"
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
//    override func prepareForInterfaceBuilder() {
//        LaTitle.text = "Title"
//    }
    
    private func commonInit(){
        view = loadViewFromNib(nibName: nibName)
//        view = loadViewFromNib(nibName: "CustomTitleVC", owner: self)
        view.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        view.frame = self.bounds
        addSubview(view)
    }
//    func commonInit() {
//        guard let view = loadViewFromNib(nibName: nibName, owner: self) else { return }
//        view.frame = self.bounds
//        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
////        setupview()
//        self.addSubview(view)
//    }
    
    func loadViewFromNib(nibName: String) -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError("Could not load view from nib \(nibName)")
        }
        return view
    }

    
}

