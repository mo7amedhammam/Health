//
//  HomeTVCell0.swift
//  Health
//
//  Created by Hamza on 01/10/2023.
//

import UIKit

class HomeTVCell0: UITableViewCell {
    @IBOutlet weak var LaTitle1: UILabel!
    @IBOutlet weak var LaTitle2: UILabel!
    
//    var title: String?{didSet {
//        LaTitle1.text = title
//    }
//    }
//    var subtitle: String?{didSet {
//        LaTitle2.text = subtitle
//    }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        setupUI()
    }
    override func prepareForReuse() {
        setupUI()
    }
    
    override func layoutSubviews() {
        // handle RTL/LTR
//        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
//        setupUI()
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
//        setupUI()
    }
    func setupUI() {
//        LaTitle1.text = "home_subtitle1".localized
//        LaTitle2.text = "home_subtitle2".localized
        
        LaTitle1.localized(string: "home_subtitle1")
        LaTitle2.localized(string: "home_subtitle2")
    }
    
}
