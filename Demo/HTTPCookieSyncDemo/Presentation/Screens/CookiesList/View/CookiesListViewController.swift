//
//  CookiesListViewController.swift
//  HTTPCookieSyncDemo
//
//  Created by Dmytrii Golovanov on 16.06.2022.
//

import Foundation
import UIKit

final class CookiesListViewController: UIViewController {
    
    // MARK: Build
    
    static func build(
        with viewModel: CookiesListViewModel
    ) -> CookiesListViewController {
        let viewControlelr = CookiesListViewController()
        viewControlelr.configure(viewModel: viewModel)
        return viewControlelr
    }
    
    // MARK: Private properties
    
    private var tableView: UITableView!
    
    private var viewModel: CookiesListViewModel!
    private var mediator: CookiesListViewMediator!
    
    // MARK: Lifecycle methods
    
    override func loadView() {
        super.loadView()
        
        tableView = UITableView(
            frame: CGRect(
                origin: .zero,
                size: view.bounds.size
            ),
            style: .grouped
        )
        view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mediator = CookiesListViewMediator(
            viewModel: viewModel,
            tableView: tableView
        )
        
        viewModel.viewDidLoad()
    }
    
    // MARK: Private methods
    
    private func configure(viewModel: CookiesListViewModel) {
        self.viewModel = viewModel
        
        self.viewModel.dataUpdated = { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        self.viewModel.showAlertController = { [weak self] alertController in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.present(
                    alertController,
                    animated: true
                )
            }
        }
    }
}
