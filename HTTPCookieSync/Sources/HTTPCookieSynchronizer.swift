//
//  HTTPCookieSynchronizer.swift
//  HTTPCookieSync
//
//  Created by Dmytrii Golovanov on 10.06.2022.
//  Copyright © 2022 Dmytrii Golovanov. All rights reserved.
//

import Foundation
import WebKit

final class HTTPCookieSynchronizer {
    private let storages: [HTTPCookieSynchronizableStorage]
    private let queue: DispatchQueue = .httpCookieSync
    
    private var previousCookies: [HTTPCookie] = []
    private var activeWorkItem: DispatchWorkItem?
    private var completionHandlersQueue: [() -> Void] = []
    
    // MARK: Init
    
    public init(
        storages: [HTTPCookieSynchronizableStorage]
    ) {
        self.storages = storages
    }
    
    // MARK: Synchronize
    
    public func synchronize(
        _ completionHandler: @escaping () -> Void = {}
    ) {
        completionHandlersQueue.append(completionHandler)
        
        executeNewWorkItem {
            self.completionHandlersQueue.forEach { completionHandler in
                completionHandler()
            }
            self.completionHandlersQueue.removeAll()
        }
    }
    
    private func executeNewWorkItem(
        completionHandler: @escaping () -> Void
    ) {
        activeWorkItem?.cancel()
        
        let workItem = DispatchWorkItem {
            
            #warning("Synchronization algorithm")
            
            completionHandler()
            self.activeWorkItem = nil
        }
        
        activeWorkItem = workItem
        queue.async(execute: workItem)
    }
}

// MARK: - Default implementation

extension HTTPCookieSynchronizer {
    public static func `default`() -> HTTPCookieSynchronizer {
        return HTTPCookieSynchronizer(
            storages: [
                HTTPCookieStorage.shared,
                WKWebsiteDataStore.default().httpCookieStore
            ]
        )
    }
}
