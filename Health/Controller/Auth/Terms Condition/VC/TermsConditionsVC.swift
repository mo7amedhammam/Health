//
//  TermsConditionsVC.swift
//  Sehaty
//
//  Created by Hamza on 21/12/2023.
//

import UIKit
import WebKit

class TermsConditionsVC: UIViewController {
    
    @IBOutlet weak var LaTitleBare: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //https://sehaty.alnadapharmacies.com/Terms.html
        if let url = URL(string: "https://sehaty.alnadapharmacies.com/Terms.html") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    
    @IBAction func BUBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
}
