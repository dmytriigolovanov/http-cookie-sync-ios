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
    func rightBarButtonItemPressed()
    func decidePolicyFor(
        wkNavigationAction: WKNavigationAction,
        inWebView webView: WKWebView,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    )
    func decidePolicyFor(
        wkNavigationResponse: WKNavigationResponse,
        inWebView webView: WKWebView,
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void
    )
}

// MARK: - MainViewModel Output

protocol MainViewModelOutput {
    var url: URL { get }
    var loadURL: ((URL) -> Void)? { get set }
    var showViewController: ((UIViewController) -> Void)? { get set }
}

typealias MainViewModel = MainViewModelInput & MainViewModelOutput

// MARK: - Default MainViewModel

final class DefaultMainViewModel: MainViewModel {
    
    let url: URL
    
    var loadURL: ((URL) -> Void)?
    var showViewController: ((UIViewController) -> Void)?
    
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
    
    func rightBarButtonItemPressed() {
        let viewModel = DefaultCookiesListViewModel()
        let viewController = CookiesListViewController.build(
            with: viewModel
        )
        showViewController?(viewController)
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
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void
    ) {
        AppConfiguration.httpCookieSyncer.sync {
            decisionHandler(.allow)
        }
    }
}
