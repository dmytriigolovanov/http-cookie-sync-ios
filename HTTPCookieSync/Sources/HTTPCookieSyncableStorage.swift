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
