//
//  HTTPCookie+Extensions.swift
//  HTTPCookieSyncDemo
//
//  Created by Dmytrii Golovanov on 17.06.2022.
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
