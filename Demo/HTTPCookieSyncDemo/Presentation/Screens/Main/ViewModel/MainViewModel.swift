//
//  MainViewModel.swift
//  HTTPCookieSyncDemo
//
//  Created by Dmytrii Golovanov on 16.06.2022.
//

import Foundation
import WebKit

// MARK: - MainViewModel Input

protocol MainViewModelInput {
    func viewDidLoad()
    func decidePolicyFor(
        wkNavigationAction: WKNavigationAction,
        inWebView webView: WKWebView,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    )
    func decidePolicyFor(
        wkNavigationResponse: WKNavigationResponse,
        inWebView webView: WKWebView,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    )
}

// MARK: - MainViewModel Output

protocol MainViewModelOutput {
    var url: URL { get }
    var loadURL: ((URL) -> Void)? { get set )
}

typealias MainViewModel = MainViewModelInput & MainViewModelOutput

// MARK: - Default MainViewModel

final class DefaultMainViewModel: MainViewModel {
    
    private let url: URL
    
    var loadURL: ((URL) -> Void)?
    
    // MARK: Init
    
    init(
        url: URL
    ) {
        self.url = url
    }
    
    // MARK: INPUT methods
    
    func viewDidLoad() {
        loadURL?(url)
    }
    
    func decidePolicyFor(
        wkNavigationAction: WKNavigationAction,
        inWebView webView: WKWebView,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        AppConfiguration.httpCookieSyncer.sync {
            decisionHandler(.allow)
        }
    }
    
    func decidePolicyFor(
        wkNavigationResponse: WKNavigationResponse,
        inWebView webView: WKWebView,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        AppConfiguration.httpCookieSyncer.sync {
            decisionHandler(.allow)
        }
    }
}
