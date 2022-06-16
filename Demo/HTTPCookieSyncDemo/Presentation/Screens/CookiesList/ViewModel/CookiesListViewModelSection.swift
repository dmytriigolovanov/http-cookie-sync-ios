//
//  CookiesListViewModelSection.swift
//  HTTPCookieSyncDemo
//
//  Created by Dmytrii Golovanov on 16.06.2022.
//

import Foundation

struct CookiesListViewModelSection {
    let title: String
    let items: [CookiesListViewModelItem]
}

// MARK: - Mapping

extension CookiesListViewModelSection {
    init(
        title: String,
        cookies: [HTTPCookie]
    ) {
        let items: [CookiesListViewModelItem] = cookies.map({
            CookiesListViewModelItem(from: $0)
        })
        
        self.init(
            title: title,
            items: items
        )
    }
}
