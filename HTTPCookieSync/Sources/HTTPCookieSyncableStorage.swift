//
//  HTTPCookieSyncableStorage.swift
//  HTTPCookieSync
//
//  Created by Dmytrii Golovanov on 10.06.2022.
//  Copyright © 2022 Dmytrii Golovanov. All rights reserved.
//

import Foundation

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
            cookies.filter({ cookie in
                oldCookies.shouldActualize(with: cookie)
            }).forEach({ cookie in
                group.enter()
                self.setCookie(cookie) {
                    group.leave()
                }
            })
            
            oldCookies.filter({ oldCookie in
                cookies.contains(where: { $0.name == oldCookie.name })
            }).forEach({ oldCookie in
                group.enter()
                self.deleteCookie(oldCookie) {
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
