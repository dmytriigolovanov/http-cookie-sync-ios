//
//  HTTPCookieSyncer.swift
//  HTTPCookieSync
//
//  Created by Dmytrii Golovanov on 10.06.2022.
//  Copyright © 2022 Dmytrii Golovanov. All rights reserved.
//

import Foundation
import WebKit

@available(*, deprecated, renamed: "HTTPCookieSyncer")
public typealias HTTPCookieSynchronizer = HTTPCookieSyncer

public final class HTTPCookieSyncer {
    private let core: HTTPCookieSyncCore
    
    /**
     - Parameter storages: The cookie storages for future synchronization.
     */
    public init(
        storages: [HTTPCookieSyncableStorage]
    ) {
        self.core = HTTPCookieSyncCore(
            storages: storages
        )
    }
    
    /**
     Synces cookies in provided storages.
        
     - Parameter completionHandler: A block to invoke once the cookies have been synchronized.
     */
    public func sync(
        _ completionHandler: @escaping () -> Void = {}
    ) {
        core.sync(completionHandler: completionHandler)
    }
    
    /**
     Synchronizes cookies in provided storages.
        
     - Parameter completionHandler: A block to invoke once the cookies have been synchronized.
     */
    @available(*, deprecated, renamed: "sync")
    public func synchronize(
        _ completionHandler: @escaping () -> Void = {}
    ) {
        sync(completionHandler)
    }
}

// MARK: - Default implementation

extension HTTPCookieSyncer {
    /**
     The default implementation of HTTPCookieSyncer.
     
     Default storages:
     ```
     HTTPCookieStorage.shared
     ```
     ```
     WKWebsiteDataStore.default().httpCookieStore
     ```
      - Returns: A new HTTPCookieSyncer instance with the default provided storages.
    */
    public static var `default`: HTTPCookieSyncer = {
        return HTTPCookieSyncer(
            storages: [
                HTTPCookieStorage.shared,
                WKWebsiteDataStore.default().httpCookieStore
            ]
        )
    }()
}
