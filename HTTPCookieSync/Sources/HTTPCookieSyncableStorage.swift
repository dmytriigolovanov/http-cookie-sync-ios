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

// MARK: - Actualization

extension HTTPCookieSyncableStorage {
    func actualize(
        with cookies: [HTTPCookie],
        completionHandler: @escaping () -> Void
    ) {
        let group = DispatchGroup()
        
        group.enter()
        getAllCookies { oldCookies in
            group.enter()
            cookies.enumerated().forEach({ index, cookie in
                guard oldCookies.shouldActualize(with: cookie) else {
                    return
                }
                group.enter()
                self.setCookie(cookie) {
                    group.leave()
                }
                
                if index == cookies.count - 1 {
                    group.leave()
                }
            })
            
            group.enter()
            oldCookies.enumerated().forEach({ index, oldCookie in
                guard cookies.contains(where: { $0.name == oldCookie.name }) else {
                    return
                }
                group.enter()
                self.deleteCookie(oldCookie) {
                    group.leave()
                }
                
                if index == oldCookies.count - 1 {
                    group.leave()
                }
            })
            group.leave()
        }
        
        group.notify(queue: .httpCookieSync) {
            completionHandler()
        }
    }
}
