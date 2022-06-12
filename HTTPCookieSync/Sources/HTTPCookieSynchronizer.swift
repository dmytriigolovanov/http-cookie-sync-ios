//
//  HTTPCookieSynchronizer.swift
//  HTTPCookieSync
//
//  Created by Dmytrii Golovanov on 10.06.2022.
//  Copyright © 2022 Dmytrii Golovanov. All rights reserved.
//

import Foundation
import WebKit

public final class HTTPCookieSynchronizer {
    private let storages: [HTTPCookieSynchronizableStorage]
    private let queue: DispatchQueue = .httpCookieSync
    
    private var previousCookies: [HTTPCookie] = []
    private var activeWorkItem: DispatchWorkItem?
    private var completionHandlersQueue: [() -> Void] = []
    
    // MARK: Init
    
    /**
     - Parameter storages: The cookie storages for future synchronization.
     */
    public init(
        storages: [HTTPCookieSynchronizableStorage]
    ) {
        self.storages = storages
    }
    
    // MARK: Synchronize
    
    /**
     Synchronizes cookies in provided storages.
        
     - Parameter completionHandler: A block to invoke once the cookies have been synchronized.
     */
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

extension HTTPCookieSynchronizer {
    /**
     The default implementation of HTTPCookieSynchronizer.
     
     Default storages:
     ```
     HTTPCookieStorage.shared
     ```
     ```
     WKWebsiteDataStore.default().httpCookieStore
     ```
      - Returns: A new HTTPCookieSynchronizer instance with the default provided storages.
    */
    public static var `default`: HTTPCookieSynchronizer = {
        return HTTPCookieSynchronizer(
            storages: [
                HTTPCookieStorage.shared,
                WKWebsiteDataStore.default().httpCookieStore
            ]
        )
    }()
}
