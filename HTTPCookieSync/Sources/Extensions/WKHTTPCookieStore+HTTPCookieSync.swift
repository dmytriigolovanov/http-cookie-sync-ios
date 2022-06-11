//
//  WKHTTPCookieStore+HTTPCookieSync.swift
//  HTTPCookieSync
//
//  Created by Dmytrii Golovanov on 10.06.2022.
//  Copyright © 2022 Dmytrii Golovanov. All rights reserved.
//

import Foundation
import WebKit

extension WKHTTPCookieStore: HTTPCookieSynchronizableStorage {
    public func deleteCookie(
        _ cookie: HTTPCookie,
        completionHandler: (() -> Void)?
    ) {
        self.delete(
            cookie,
            completionHandler: completionHandler
        )
    }
}
