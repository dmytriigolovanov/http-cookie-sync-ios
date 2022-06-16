//
//  CookiesListViewModelItem.swift
//  HTTPCookieSyncDemo
//
//  Created by Dmytrii Golovanov on 16.06.2022.
//

import Foundation

struct CookiesListViewModelItem {
    let title: String
    let details: String
    let extendedDetails: String
}

// MARK: - Mapping

extension CookiesListViewModelItem {
    init(
        from cookie: HTTPCookie
    ) {
        self.init(
            title: cookie.name,
            details: cookie.value,
            extendedDetails: cookie.description
        )
    }
}
