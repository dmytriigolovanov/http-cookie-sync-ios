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
    
    func isRelevant(
        than cookie: HTTPCookie
    ) -> Bool {
        guard
            let created = self.created,
            let cookieCreated = cookie.created
        else {
            return false
        }
        
        return cookieCreated < created
    }
}
