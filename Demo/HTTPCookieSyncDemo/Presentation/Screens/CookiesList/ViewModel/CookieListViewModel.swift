//
//  CookieListViewModel.swift
//  HTTPCookieSyncDemo
//
//  Created by Dmytrii Golovanov on 16.06.2022.
//

import Foundation
import HTTPCookieSync

// MARK: - CookiesListViewModel Input

protocol CookiesListViewModelInput {
    func viewDidLoad()
    func didSelectTableViewRow(at indexPath: IndexPath)
}

// MARK: - CookiesListViewModel Output

protocol CookiesListViewModelOutput {
    var sections: [CookiesListViewModelSection] { get }
    var dataUpdated: (() -> Void)? { get set }
}

typealias CookiesListViewModel = CookiesListViewModelInput & CookiesListViewModelOutput

// MARK: - Default CookiesListViewModel

final class DefaultCookiesListViewModel: CookiesListViewModel {
    
    // MARK: Private properties
    
    private let storages: [HTTPCookieSyncableStorage]
    
    // MARK: OUTPUT properties
    
    private(set) var sections: [CookiesListViewModelSection] = []
    var dataUpdated: (() -> Void)?
    
    // MARK: Init
    
    init() {
        self.storages = [
            AppConfiguration.httpCookieStorage,
            AppConfiguration.websiteDataSource.httpCookieStore
        ]
    }
    
    // MARK: Private methods
    
    private func updateData() {
        self.sections = []
        var sections: [CookiesListViewModelSection] = []
        
        DispatchQueue.global(qos: .userInitiated).async {
            let dispatchGroup = DispatchGroup()
            
            self.storages.forEach { storage in
                
                dispatchGroup.enter()
                storage.getAllCookies { cookies in
                    let section = CookiesListViewModelSection(
                        title: "\(type(of: storage))",
                        cookies: cookies
                    )
                    sections.append(section)
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self.sections = sections
                self.dataUpdated?()
            }
        }
    }
    
    // MARK: INPUT methods
    
    func viewDidLoad() {
        updateData()
    }
    
    func didSelectTableViewRow(at indexPath: IndexPath) {
        
    }
}
