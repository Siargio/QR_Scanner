//
//  AssemblyModuleBuilder.swift
//  QR_Scanner
//
//  Created by Sergio on 11.03.23.
//

import UIKit

// MARK: - Protocols
protocol AssemblyBuilderProtocol {
    func createScannerModule(router: RouterProtocol) -> UIViewController
    func createWebViewModule(router: RouterProtocol, url: String) -> UIViewController
}

// MARK: - Class
final class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    func createScannerModule(router: RouterProtocol) -> UIViewController {
        let viewController = ScannerViewController()
        let presenter = ScannerPresenter(scannerController: viewController, router: router)
        viewController.presenter = presenter
        return viewController
    }

    func createWebViewModule(router: RouterProtocol, url: String) -> UIViewController {
        let viewController = WebViewController(url: url)
        let presenter = WebViewPresenter(webViewController: viewController, router: router)
        viewController.presenter = presenter
        return viewController
    }
}
