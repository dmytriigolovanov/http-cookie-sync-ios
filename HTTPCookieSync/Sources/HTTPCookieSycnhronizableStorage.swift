//
//  HTTPCookieSynchronizableStorage.swift
//  HTTPCookieSync
//
//  Created by Dmytrii Golovanov on 10.06.2022.
//  Copyright © 2022 Dmytrii Golovanov. All rights reserved.
//

import Foundation

public protocol HTTPCookieSynchronizableStorage {
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
