//
//  MainViewController.swift
//  HTTPCookieSyncDemo
//
//  Created by Dmytrii Golovanov on 12.06.2022.
//

import UIKit
import WebKit

final class MainViewController: UIViewController {
    
    // MARK: Build
    
    static func build(
        with viewModel: MainViewModel
    ) -> MainViewController {
        let storyboard = UIStoryboard(
            name: "Main",
            bundle: nil
        )
        guard let viewController = storyboard.instantiateInitialViewController() as? MainViewController else {
            fatalError()
        }
        viewController.configure(viewModel: viewModel)
        return viewController
    }
    
    // MARK: Private properties
    
    private var webView: WKWebView!
    private var rightBarButtonItem: UIBarButtonItem!
    
    private var viewModel: MainViewModel!
    private var mediator: MainViewMediator!
    
    // MARK: Lifecycle methods
    
    override func loadView() {
        super.loadView()
        
        webView = WKWebView(
            frame: CGRect(
                origin: .zero,
                size: view.bounds.size
            ),
            configuration: AppConfiguration.webViewConfiguration
        )
        view.addSubview(webView)
        
        rightBarButtonItem = UIBarButtonItem(
            title: "Cookies List",
            style: .plain,
            target: self,
            action: #selector(barButtonItemPressed(_:))
        )
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mediator = MainViewMediator(
            viewModel: viewModel,
            webView: webView
        )
        
        viewModel.viewDidLoad()
    }
    
    // MARK: Private methods
    
    private func configure(viewModel: MainViewModel) {
        self.viewModel = viewModel
        
        self.viewModel.loadURL = { [weak self] url in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                let urlRequest = URLRequest(url: url)
                self.webView.load(urlRequest)
            }
        }
        self.viewModel.showViewController = { [weak self] viewController in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.show(
                    viewController,
                    sender: self
                )
            }
        }
    }
    
    @objc private func barButtonItemPressed(
        _ sender: UIBarButtonItem
    ) {
        switch sender {
        case rightBarButtonItem:
            viewModel.rightBarButtonItemPressed()
        default:
            break
        }
        
    }
}
