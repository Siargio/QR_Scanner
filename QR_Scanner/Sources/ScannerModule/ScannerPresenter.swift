//
//  ScannerPresenter.swift
//  QR_Scanner
//
//  Created by Sergio on 11.03.23.
//

import UIKit

// MARK: - Protocols
protocol ScannerPresenterProtocol: AnyObject {
    func goToWebsite(url : String)
}

// MARK: - Class
final class ScannerPresenter {

    // MARK: - Properties
    weak var scannerController: ScannerViewProtocol?
    var router: RouterProtocol?

    // MARK: - Init
    init(scannerController: ScannerViewProtocol, router: RouterProtocol) {
        self.scannerController = scannerController
        self.router = router
    }
}

// MARK: - ScannerPresenterProtocol
extension ScannerPresenter: ScannerPresenterProtocol {
    func goToWebsite(url: String) {
        router?.showWebView(url: url)
    }
}
