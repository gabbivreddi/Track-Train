//
//  YouTubePlayerView.swift
//  Track&Train
//
//  Created by Venkata reddy Gabbi on 5/29/25.
//

import SwiftUI
import SwiftData // Note: SwiftData is imported but not yet used in this specific file.
import WebKit // Import WebKit for embedding the YouTube player


struct YouTubePlayerView: UIViewRepresentable {
    let videoID: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.configuration.allowsInlineMediaPlayback = true
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/") else {
            uiView.loadHTMLString("<html><body><p>Error: Could not load video.</p></body></html>", baseURL: nil)
            return
        }
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: youtubeURL))
    }
}
