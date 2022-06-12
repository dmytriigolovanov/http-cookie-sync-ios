//
//  HTTPCookieStorage+HTTPCookieSync.swift
//  HTTPCookieSync
//
//  Created by Dmytrii Golovanov on 10.06.2022.
//  Copyright © 2022 Dmytrii Golovanov. All rights reserved.
//

import Foundation

extension HTTPCookieStorage: HTTPCookieSyncableStorage {
    public func getAllCookies(
        _ completionHandler: @escaping ([HTTPCookie]) -> Void
    ) {
        let cookies = self.cookies ?? []
        completionHandler(cookies)
    }
    
    public func setCookie(
        _ cookie: HTTPCookie,
        completionHandler: (() -> Void)?
    ) {
        self.setCookie(cookie)
        completionHandler?()
    }
    
    public func deleteCookie(
        _ cookie: HTTPCookie,
        completionHandler: (() -> Void)?
    ) {
        self.deleteCookie(cookie)
        completionHandler?()
    }
}
