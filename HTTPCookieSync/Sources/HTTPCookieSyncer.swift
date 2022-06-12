//
//  HTTPCookieSyncer.swift
//  HTTPCookieSync
//
//  Created by Dmytrii Golovanov on 10.06.2022.
//  Copyright © 2022 Dmytrii Golovanov. All rights reserved.
//

import Foundation
import WebKit

@available(*, deprecated, renamed: "HTTPCookieSyncer")
typealias HTTPCookieSynchronizer = HTTPCookieSyncer

public final class HTTPCookieSyncer {
    private let storages: [HTTPCookieSyncableStorage]
    private let queue: DispatchQueue = .httpCookieSync
    
    private var previousCookies: [HTTPCookie] = []
    private var activeWorkItem: DispatchWorkItem?
    private var completionHandlersQueue: [() -> Void] = []
    
    // MARK: Init
    
    /**
     - Parameter storages: The cookie storages for future synchronization.
     */
    public init(
        storages: [HTTPCookieSyncableStorage]
    ) {
        self.storages = storages
    }
    
    // MARK: Sync
    /**
     Synces cookies in provided storages.
        
     - Parameter completionHandler: A block to invoke once the cookies have been synchronized.
     */
    public func sync(
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
    
    /**
     Synchronizes cookies in provided storages.
        
     - Parameter completionHandler: A block to invoke once the cookies have been synchronized.
     */
    @available(*, deprecated, renamed: "sync")
    public func synchronize(
        _ completionHandler: @escaping () -> Void = {}
    ) {
        sync(completionHandler)
    }
    
    // MARK: DispatchWorkItem
    
    private func executeNewWorkItem(
        completionHandler: @escaping () -> Void
    ) {
        activeWorkItem?.cancel()
        
        let workItem = DispatchWorkItem {
            let group = DispatchGroup()
            
            group.enter()
            self.getActualCookies { actualCookies in
                self.storages.forEach { storage in
                    group.enter()
                    storage.actualize(with: actualCookies) {
                        group.leave()
                    }
                }
                group.leave()
            }
            
            group.notify(queue: self.queue) {
                completionHandler()
                self.activeWorkItem = nil
            }
        }
        
        activeWorkItem = workItem
        queue.async(execute: workItem)
    }
    
    // MARK: Actual cookies
    
    private func getActualCookies(
        _ completionHandler: @escaping ([HTTPCookie]) -> Void
    ) {
        var actualCookies: [HTTPCookie] = self.previousCookies
        
        let group = DispatchGroup()
        
        storages.forEach { storage in
            group.enter()
            storage.getAllCookies { cookies in
                
                cookies.forEach { cookie in
                    actualCookies.actualize(with: cookie)
                }
                
                group.leave()
            }
        }
        
        group.notify(queue: .httpCookieSync) {
            completionHandler(actualCookies)
        }
    }
}

// MARK: - Default implementation

extension HTTPCookieSyncer {
    /**
     The default implementation of HTTPCookieSyncer.
     
     Default storages:
     ```
     HTTPCookieStorage.shared
     ```
     ```
     WKWebsiteDataStore.default().httpCookieStore
     ```
      - Returns: A new HTTPCookieSyncer instance with the default provided storages.
    */
    public static var `default`: HTTPCookieSyncer = {
        return HTTPCookieSyncer(
            storages: [
                HTTPCookieStorage.shared,
                WKWebsiteDataStore.default().httpCookieStore
            ]
        )
    }()
}
