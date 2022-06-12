//
//  ViewController.swift
//  HTTPCookieSyncDemo
//
//  Created by Dmytrii Golovanov on 12.06.2022.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    private var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create WebView
        
        webView = WKWebView(
            frame: CGRect(
                origin: .zero,
                size: view.bounds.size
            ),
            configuration: AppConfiguration.webViewConfiguration
        )
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        // Load URL
        
        if let url = URL(string: "https://github.com/dmytriigolovanov/http-cookie-sync-ios") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

// MARK: - WKNavigationDelegate

extension ViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        AppConfiguration.httpCookieSyncer.sync {
            decisionHandler(.allow)
        }
    }
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void
    ) {
        AppConfiguration.httpCookieSyncer.sync {
            decisionHandler(.allow)
        }
    }
}
