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
}

// MARK: - Array of HTTPCookie

extension Array where Element: HTTPCookie {
    func shouldActualize(
        with cookie: Element
    ) -> Bool {
        guard let oldCookie = self.first(where: { $0.name == cookie.name }) else {
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
    
    mutating func actualize(
        with cookie: Element
    ) {
        guard shouldActualize(with: cookie) else {
            return
        }
        
        enumerated().filter({ _, oldCookie in
            oldCookie.name == cookie.name
        }).forEach({ index, _ in
            remove(at: index)
        })
        
        append(cookie)
    }
}
