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
    func createWebViewModule(router: RouterProtocol) -> UIViewController
}

// MARK: - Class

final class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    
    func createScannerModule(router: RouterProtocol) -> UIViewController {
        let view = ScannerViewController()
        let presenter = ScannerPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }

    func createWebViewModule(router: RouterProtocol) -> UIViewController {
        let view = WebViewController()
        let presenter = WebViewPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }
}
