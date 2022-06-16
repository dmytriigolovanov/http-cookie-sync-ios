//
//  MainViewMediator.swift
//  HTTPCookieSyncDemo
//
//  Created by Dmytrii Golovanov on 16.06.2022.
//

import Foundation
import WebKit

final class MainViewMediator: NSObject {
    private let viewModel: MainViewModel
    private let webView: WKWebView
    
    // MARK: Init
    
    init(
        viewModel: MainViewModel,
        webView: WKWebView
    ) {
        self.viewModel = viewModel
        self.webView = webView
        super.init()
        
        setupWebView()
    }
    
    // MARK: Setup
    
    private func setupWebView() {
        webView.navigationDelegate = self
    }
}

// MARK: - WKNavigationDelegate

extension MainViewMediator: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        viewModel.decidePolicyFor(
            wkNavigationAction: navigationAction,
            inWebView: webView,
            decisionHandler: decisionHandler)
    }
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void
    ) {
        viewModel.decidePolicyFor(
            wkNavigationResponse: navigationResponse,
            inWebView: webView,
            decisionHandler: decisionHandler)
    }
}
