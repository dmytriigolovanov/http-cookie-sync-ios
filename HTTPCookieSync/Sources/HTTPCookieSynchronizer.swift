//
//  HTTPCookieSynchronizer.swift
//  HTTPCookieSync
//
//  Created by Dmytrii Golovanov on 10.06.2022.
//  Copyright © 2022 Dmytrii Golovanov. All rights reserved.
//

import Foundation
import WebKit

final class HTTPCookieSynchronizer {
    private let storages: [HTTPCookieSynchronizableStorage]
    
    // MARK: Init
    
    public init(
        storages: [HTTPCookieSynchronizableStorage]
    ) {
        self.storages = storages
    }
    
    // MARK: Synchronize
    
    public func sync(
        _ completionHandler: @escaping () -> Void = {}
    ) {
        
    }
}

// MARK: - Default implementation

extension HTTPCookieSynchronizer {
    public static func `default`() -> HTTPCookieSynchronizer {
        return HTTPCookieSynchronizer(
            storages: [
                HTTPCookieStorage.shared,
                WKWebsiteDataStore.default().httpCookieStore
            ]
        )
    }
}
