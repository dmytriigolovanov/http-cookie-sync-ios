//
//  CookiesListViewModelItem.swift
//  HTTPCookieSyncDemo
//
//  Created by Dmytrii Golovanov on 16.06.2022.
//

import Foundation

struct CookiesListViewModelItem {
    let title: String
    let value: String
    let details: String
}

// MARK: - Mapping

extension CookiesListViewModelItem {
    init(
        from cookie: HTTPCookie
    ) {
        var details = """
        value: \(cookie.value)
        domain: \(cookie.domain)
        path: \(cookie.path)
        """
        
        if let createdDate = cookie.createdDate {
            details.append("\ncreated: \(createdDate)")
        }
        if let expiresDate = cookie.expiresDate {
            details.append("\nexpires: \(expiresDate)")
        }
        
        self.init(
            title: cookie.name,
            value: cookie.value,
            details: details
        )
    }
}
