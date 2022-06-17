//
//  HTTPCookieSyncableStorage.swift
//  HTTPCookieSync
//
//  Created by Dmytrii Golovanov on 10.06.2022.
//  Copyright © 2022 Dmytrii Golovanov. All rights reserved.
//

import Foundation

@available(*, deprecated, renamed: "HTTPCookieSyncableStorage")
public typealias HTTPCookieSynchronizableStorage = HTTPCookieSyncableStorage

public protocol HTTPCookieSyncableStorage {
    func getAllCookies(
        _ completionHandler: @escaping ([HTTPCookie]) -> Void
    )
    
    func setCookie(
        _ cookie: HTTPCookie,
        completionHandler: (() -> Void)?
    )
    
    func deleteCookie(
        _ cookie: HTTPCookie,
        completionHandler: (() -> Void)?
    )
}

extension HTTPCookieSyncableStorage {
    func actualize(
        with cookies: [HTTPCookie]
    ) {
        let semaphore = DispatchSemaphore(value: 0)
        
        getAllCookies { oldCookies in
            // Set new/relevant cookies
            cookies.filter({ cookie in
                guard
                    let oldCookie = oldCookies.first(where: {
                        $0.isSame(to: cookie)
                    })
                else {
                    return true
                }
                return cookie.isRelevant(than: oldCookie)
            }).forEach({ cookie in
                setCookie(cookie) {
                    // semaphore.signal()
                }
                // semaphore.wait()
            })
            
            // Delete old cookies
            oldCookies.filter({ oldCookie in
                !cookies.contains(where: {
                    $0.isSame(to: oldCookie)
                })
            }).forEach({ oldCookie in
                deleteCookie(oldCookie) {
                    // semaphore.signal()
                }
                // semaphore.wait()
            })
            
            semaphore.signal()
        }
        semaphore.wait()
    }
}
