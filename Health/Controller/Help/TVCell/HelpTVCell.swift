//
//  HelpTVCell.swift
//  Sehaty
//
//  Created by Hamza on 16/12/2023.
//

import UIKit
import WebKit

class HelpTVCell: UITableViewCell {

    @IBOutlet weak var ViewLine: UIView!
    @IBOutlet weak var LaTitle1: UILabel!
    @IBOutlet weak var LaTitle2: UILabel!

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var ViewBtn: UIView!
    
    @IBOutlet weak var SuperWebView: WKWebView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        SuperWebView.translatesAutoresizingMaskIntoConstraints = false

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
