//
//  HTTPCookie+HTTPCookieSync.swift
//  HTTPCookieSync
//
//  Created by Dmytrii Golovanov on 10.06.2022.
//  Copyright © 2022 Dmytrii Golovanov. All rights reserved.
//

import Foundation

extension HTTPCookie {
    var created: TimeInterval? {
        return properties?[.created] as? TimeInterval
    }
    
    var createdDate: Date? {
        guard let timeInterval = self.created else {
            return nil
        }
        return Date(timeIntervalSinceReferenceDate: timeInterval)
    }
    
    func isSame(
        to cookie: HTTPCookie
    ) -> Bool {
        return name == cookie.name && domain == cookie.domain
    }
}

// MARK: - Array of HTTPCookie

extension Array where Element: HTTPCookie {
    func shouldActualize(
        with cookie: Element
    ) -> Bool {
        guard let oldCookie = self.first(where: { $0.isSame(to: cookie) }) else {
            return true
        }
        
        guard
            let cookieCreated = cookie.created,
            let oldCookieCreated = oldCookie.created
        else {
            return false
        }
        
        return cookieCreated < oldCookieCreated
    }
}
