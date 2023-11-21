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
        self.semanticContentAttribute = .forceRightToLeft

        // Apply custom CSS to ensure right-to-left display
        let customCSS = """
            <style>
                body {
                    font-size: 40px;
                    direction: rtl; /* Right-to-left direction */
                    text-align: right; /* Right-align text */
                }
            </style>
        """
        
        // Wrap the HTML content with a <div> element with dir="auto" to let the browser determine the text direction
        let finalHTML = "<html dir=\"auto\"><head>\(customCSS)</head><body>\(htmlString)</body></html>"
        
        // Load the HTML string into the WKWebView
        self.loadHTMLString(finalHTML, baseURL: nil)
    }
}
