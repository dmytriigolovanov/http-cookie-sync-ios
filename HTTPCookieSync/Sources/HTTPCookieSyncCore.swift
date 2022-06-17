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
    
    private var syncedCookies: [HTTPCookie] = []
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
        
        executeNewWorkItem { [weak self] in
            guard let self = self else { return }
            
            self.activeWorkItem = nil
            self.completionHandlersQueue.forEach { completionHandler in
                completionHandler()
            }
            self.completionHandlersQueue.removeAll()
        }
    }
    
    // MARK: DispatchWorkItem
    
    private func createWorkItem(
        completionHandler: @escaping () -> Void
    ) -> DispatchWorkItem {
        return DispatchWorkItem {
            let semaphore = DispatchSemaphore(value: 0)
            
            self.getSyncedCookies { syncedCookies in
                self.syncedCookies = syncedCookies
                semaphore.signal()
            }
            semaphore.wait()
            
            self.storages.forEach { storage in
                storage.actualize(with: self.syncedCookies)
            }
            
            completionHandler()
        }
    }
    
    private func executeNewWorkItem(
        completionHandler: @escaping () -> Void
    ) {
        activeWorkItem?.cancel()
        
        let workItem = createWorkItem(
            completionHandler: completionHandler
        )
        
        activeWorkItem = workItem
        queue.async(execute: workItem)
    }
    
    // MARK: Synced cookies
    
    private func getSyncedCookies(
        completionHandler: @escaping ([HTTPCookie]) -> Void
    ) {
        var syncedCookies: [HTTPCookie] = self.syncedCookies
        
        let semaphore = DispatchSemaphore(value: 0)
        
        storages.forEach { storage in
            storage.getAllCookies { cookies in
                cookies.forEach { cookie in
                    var relevanceCookie: HTTPCookie = cookie
                    
                    let sameCookies = syncedCookies.filter({
                        $0.isSame(to: cookie)
                    })
                    
                    sameCookies.filter({
                        $0.isRelevant(than: relevanceCookie)
                    }).forEach({ sameCookie in
                        relevanceCookie = sameCookie
                    })

                    sameCookies.enumerated().filter({ _, sameCookie in
                        sameCookie != relevanceCookie
                    }).forEach({ index, _ in
                        syncedCookies.remove(at: index)
                    })
                    
                    syncedCookies.append(relevanceCookie)
                }
                semaphore.signal()
            }
            semaphore.wait()
        }
        
        completionHandler(syncedCookies)
    }
}
