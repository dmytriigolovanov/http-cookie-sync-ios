//
//  CookiesListViewMediator.swift
//  HTTPCookieSyncDemo
//
//  Created by Dmytrii Golovanov on 16.06.2022.
//

import Foundation
import UIKit

final class CookiesListViewMediator: NSObject {
    private let viewModel: CookiesListViewModel
    private let tableView: UITableView
    
    // MARK: Init
    
    init(
        viewModel: CookiesListViewModel,
        tableView: UITableView
    ) {
        self.viewModel = viewModel
        self.tableView = tableView
        super.init()
        
        setupTableView()
    }
    
    // MARK: Setup
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDataSource

extension CookiesListViewMediator: UITableViewDataSource {
    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return viewModel.sections[section].items.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        let item = viewModel.sections[indexPath.section].items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.value
        
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        return viewModel.sections[section].title
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: - UITableViewDelegate

extension CookiesListViewMediator: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        viewModel.didSelectTableViewRow(at: indexPath)
    }
}
