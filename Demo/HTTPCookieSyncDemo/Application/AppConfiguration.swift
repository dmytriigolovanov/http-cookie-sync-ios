//
//  AppConfiguration.swift
//  HTTPCookieSyncDemo
//
//  Created by Dmytrii Golovanov on 12.06.2022.
//

import Foundation
import WebKit
import HTTPCookieSync

struct AppConfiguration {
    static var urlSession: URLSession = {
        return URLSession.shared
    }()
    
    static var httpCookieStorage: HTTPCookieStorage = {
        guard let httpCookieStorage = urlSession.configuration.httpCookieStorage else {
            fatalError("Provided URLSession doesn't contain HTTPCookieStorage.")
        }
        return httpCookieStorage
    }()
    
    // MARK: WebKit
    
    static var websiteDataSource: WKWebsiteDataStore = {
        return WKWebsiteDataStore.default()
    }()
    
    static var processPool: WKProcessPool = {
       return WKProcessPool()
    }()
    
    static var webViewConfiguration: WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = websiteDataSource
        configuration.processPool = processPool
        return WKWebViewConfiguration()
    }
    
    // MARK: HTTPCookieSync
    
    static var httpCookieSyncer: HTTPCookieSyncer = {
        return HTTPCookieSyncer(
            storages: [
                httpCookieStorage,
                websiteDataSource.httpCookieStore
            ]
        )
    }()
}
