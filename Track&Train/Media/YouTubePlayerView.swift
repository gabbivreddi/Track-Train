//
//  YouTubePlayerView.swift
//  Track&Train
//
//  Created by Venkata reddy Gabbi on 5/29/25.
//

import SwiftUI
import WebKit // Import WebKit for embedding the YouTube player

struct YouTubePlayerView: UIViewRepresentable {
    let videoID: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.configuration.allowsInlineMediaPlayback = true // Allows video to play inline
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Construct the correct YouTube embed URL
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)") else {
            // If the URL is invalid, show an error message
            uiView.loadHTMLString("<html><body><p>Error: Invalid YouTube video ID.</p></body></html>", baseURL: nil)
            return
        }
        
        // Prevent scrolling in the web view
        uiView.scrollView.isScrollEnabled = false
        // Load the YouTube video request
        uiView.load(URLRequest(url: youtubeURL))
    }
}
