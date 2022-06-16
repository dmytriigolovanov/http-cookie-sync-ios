//
//  AppDelegate.swift
//  HTTPCookieSyncDemo
//
//  Created by Dmytrii Golovanov on 12.06.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let rootViewController = startMain()
        self.window = UIWindow()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func startMain() -> UIViewController {
        guard let url = URL(string: "https://github.com/dmytriigolovanov/http-cookie-sync-ios") else {
            fatalError()
        }
        let viewModel = DefaultMainViewModel(url: url)
        let viewController = MainViewController.build(
            with: viewModel
        )
        let navigationController = UINavigationController(
            rootViewController: viewController
        )
        return navigationController
    }
}
