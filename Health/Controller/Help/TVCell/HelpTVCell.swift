//
//  HelpTVCell.swift
//  Sehaty
//
//  Created by Hamza on 16/12/2023.
//

import UIKit
import WebKit

class HelpTVCell: UITableViewCell,WKNavigationDelegate {
    
    @IBOutlet weak var ViewLine: UIView!
    @IBOutlet weak var LaTitle1: UILabel!
    @IBOutlet weak var LaTitle1Bg: UIView!
    @IBOutlet weak var ViewBtn: UIView!
    @IBOutlet weak var videoContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var webView: WKWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        webView.translatesAutoresizingMaskIntoConstraints = false
        setupWebView()
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
    }
    
    private func setupWebView() {
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = false
//        webView.configuration.preferences.javaScriptEnabled = true
        webView.configuration.allowsInlineMediaPlayback = true
        webView.configuration.mediaTypesRequiringUserActionForPlayback = []
    }
    
    private func setupUI() {
//        LaTitle1Bg.applyHorizontalGradient()
        ViewBtn.layer.cornerRadius = 8
        ViewBtn.clipsToBounds = true
    }
    
    func configure(with model: ModelHelp, play: Bool) {
        LaTitle1.text = model.title
        
        if play {
//            expandVideoPlayer()
//            if let url = URL(string: model.videoURL ?? "") {
//                webView.load(URLRequest(url: url))
                loadYouTubeVideo(url: model.videoURL)
//            }
        } else {
//            collapseVideoPlayer()
//            webView.loadHTMLString("", baseURL: nil) // Cancel loading
        }
    }
    
    func expandVideoPlayer() {
//        videoContainerHeightConstraint.constant = 200
//        ViewBtn.isHidden = false
    }
    
    func collapseVideoPlayer() {
//        videoContainerHeightConstraint.constant = 0
//        ViewBtn.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Optional: Add code here if needed after video loads
    }
    
}

extension HelpTVCell {
    private func loadYouTubeVideo(url: String?) {
        guard let urlString = url,
              let videoID = extractYouTubeID(from: urlString) else {
            print("Failed to extract YouTube ID from URL: \(url ?? "nil")")
            return
        }
        
        print("Extracted YouTube ID: \(videoID)") // Debug
        
        let embedHTML = """
        <html>
        <head>
            <style>
                body { margin:0; padding:0; background-color:black; }
            </style>
        </head>
        <body>
            <iframe width="100%" height="100%" 
                    src="https://www.youtube.com/embed/\(videoID)?playsinline=1&autoplay=1&rel=0" 
                    frameborder="0" 
                    allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" 
                    allowfullscreen>
            </iframe>
        </body>
        </html>
        """
        
        webView.loadHTMLString(embedHTML, baseURL: nil)
    }
    
    private func extractYouTubeID(from url: String) -> String? {
        // Handle embed URLs directly
        if url.contains("youtube.com/embed/") {
            return url.components(separatedBy: "youtube.com/embed/").last?.components(separatedBy: "?").first
        }
        
        // Handle standard watch URLs
        if url.contains("youtube.com/watch") {
            return URLComponents(string: url)?.queryItems?.first(where: { $0.name == "v" })?.value
        }
        
        // Handle youtu.be short URLs
        if url.contains("youtu.be/") {
            return url.components(separatedBy: "youtu.be/").last?.components(separatedBy: "?").first
        }
        
        // Handle URLs with &v= parameter
        if let range = url.range(of: "v=") {
            let videoIDPart = url[range.upperBound...]
            if let ampersandIndex = videoIDPart.firstIndex(of: "&") {
                return String(videoIDPart[..<ampersandIndex])
            }
            return String(videoIDPart)
        }
        
        // Fallback to regex for other cases
        let pattern = "(?:youtube\\.com\\/(?:[^\\/]+\\/.+\\/|(?:v|e(?:mbed)?)\\/|.*[?&]v=)|youtu\\.be\\/)([^\"&?\\/\\s]{11})"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive),
              let match = regex.firstMatch(in: url, range: NSRange(url.startIndex..., in: url)) else {
            return nil
        }
        
        return String(url[Range(match.range(at: 1), in: url)!])
    }
}
