//
//  HTMLStringView.swift
//  AIVideoMaker
//
//  Created by Kiran Jamod on 17/02/26.
//

import SwiftUI
import WebKit

struct HTMLStringView: UIViewRepresentable {
    let htmlContent: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let htmlString = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <style>
                body {
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
                    font-size: 16px;
                    line-height: 1.6;
                    color: rgba(255, 255, 255, 0.9);
                    background-color: transparent;
                    padding: 20px;
                    margin: 0;
                }
                h1, h2, h3, h4, h5, h6 {
                    color: #FFFFFF;
                    margin-top: 24px;
                    margin-bottom: 12px;
                    font-weight: 600;
                }
                h1 { font-size: 28px; }
                h2 { font-size: 24px; }
                h3 { font-size: 20px; }
                p {
                    margin-bottom: 16px;
                }
                a {
                    color: #3B82F6;
                    text-decoration: none;
                }
                ul, ol {
                    margin-bottom: 16px;
                    padding-left: 24px;
                }
                li {
                    margin-bottom: 8px;
                }
                strong {
                    color: #FFFFFF;
                    font-weight: 600;
                }
            </style>
        </head>
        <body>
            \(htmlContent)
        </body>
        </html>
        """
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
}
