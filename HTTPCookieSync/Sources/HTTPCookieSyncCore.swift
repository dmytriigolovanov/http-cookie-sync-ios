//
//  HTTPCookieSyncCore.swift
//  HTTPCookieSync
//
//  Created by Dmytrii Golovanov on 17.06.2022.
//  Copyright © 2022 Dmytrii Golovanov. All rights reserved.
//

import Foundation

final class HTTPCookieSyncCore: NSObject {
    private let storages: [HTTPCookieSyncableStorage]
    private let queue: DispatchQueue = .httpCookieSync
    
    private var previousCookies: [HTTPCookie] = []
    private var activeWorkItem: DispatchWorkItem?
    private var completionHandlersQueue: [() -> Void] = []
    
    // MARK: Init
    
    init(
        storages: [HTTPCookieSyncableStorage]
    ) {
        self.storages = storages
    }
    
    func sync(
        completionHandler: @escaping () -> Void
    ) {
        completionHandlersQueue.append(completionHandler)
        
        executeNewWorkItem {
            self.completionHandlersQueue.forEach { completionHandler in
                completionHandler()
            }
            self.completionHandlersQueue.removeAll()
        }
    }
    
    // MARK: DispatchWorkItem
    
    private func executeNewWorkItem(
        completionHandler: @escaping () -> Void
    ) {
        activeWorkItem?.cancel()
        
        let workItem = DispatchWorkItem {
            self.getActualCookies { actualCookies in
                self.actualizeStorages(with: actualCookies) {
                    completionHandler()
                    self.activeWorkItem = nil
                }
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
        
        group.enter()
        storages.enumerated().forEach { index, storage in
            group.enter()
            storage.getAllCookies { cookies in
                
                cookies.forEach { cookie in
                    actualCookies.actualize(with: cookie)
                }
                
                group.leave()
            }
            
            if index == storages.count - 1 {
                group.leave()
            }
        }
        
        group.notify(queue: .httpCookieSync) {
            completionHandler(actualCookies)
        }
    }
    
    // MARK: Actualize
    
    private func actualizeStorages(
        with cookies: [HTTPCookie],
        _ completionHandler: @escaping () -> Void
    ) {
        let group = DispatchGroup()
        
        group.enter()
        self.storages.enumerated().forEach { index, storage in
            group.enter()
            storage.actualize(with: cookies) {
                group.leave()
            }
            
            if index == storages.count - 1 {
                group.leave()
            }
        }
        
        group.notify(queue: .httpCookieSync) {
            completionHandler()
        }
    }
}
