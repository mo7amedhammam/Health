//
//  ExWkWebView.swift
//  Sehaty
//
//  Created by wecancity on 14/10/2023.
//

import WebKit

extension WKWebView {
    func loadHTMLStringWithAutoDirection(_ htmlString: String) {
        // Set the semanticContentAttribute to .forceRightToLeft
        //#F5F5FF
        self.semanticContentAttribute = .forceRightToLeft
        // Apply custom CSS to ensure right-to-left display
        let customCSS = """
                
            <style>
                body {
                    font-size: 50px;
                    color :#2D2DB2;
                    line-height: 1.5;
                    background-color: #F5F5FF;
                    direction: rtl; /* Right-to-left direction */
                    text-align: right; /* Right-align text */
                    padding-left: 15px; /* Add 10px padding to the left */
                    padding-right: 15px;
                    padding-bottom: 50px; /* Add 50px padding to the bottom */
                }
        
          footer {
            font-size: 60px; /* Increase the font size for the footer */
            padding-top: 20px; /* Add 20px padding to the top of the footer */
            background-color: #CCCCCC; /* Change the background color of the footer */
            text-align: center; /* Center-align text in the footer */
                   
        }
        
            </style>
        """
        
        // Wrap the HTML content with a <div> element with dir="auto" to let the browser determine the text direction
        let finalHTML = "<html dir=\"auto\"><head>\(customCSS)</head><body>\(htmlString)</body></html>"
        
        // Load the HTML string into the WKWebView
        self.loadHTMLString(finalHTML, baseURL: nil)
    }
}
