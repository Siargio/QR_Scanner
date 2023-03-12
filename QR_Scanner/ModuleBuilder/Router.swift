//
//  Router.swift
//  QR_Scanner
//
//  Created by Sergio on 11.03.23.
//

import UIKit

// MARK: - Protocols
protocol RouterMain: AnyObject {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showWebView(url: String)
}

// MARK: - Class
final class Router: RouterProtocol {
    var navigationController: UINavigationController? 
    var assemblyBuilder: AssemblyBuilderProtocol?

    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol){
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }

    func initialViewController() {
        if let navigationController = navigationController {
            guard let scannerViewController = assemblyBuilder?.createScannerModule(router: self) else { return }
            navigationController.viewControllers = [scannerViewController]
        }
    }

    func showWebView(url: String) {
        let navigationController = navigationController
        guard let webViewController = assemblyBuilder?.createWebViewModule(router: self, url: url) else { return }
        navigationController?.pushViewController(webViewController, animated: true)
    }
}
