//
//  ScannerPresenter.swift
//  QR_Scanner
//
//  Created by Sergio on 11.03.23.
//

import UIKit

// MARK: - Protocols

protocol ScannerPresenterProtocol: AnyObject {

}

// MARK: - Class

final class ScannerPresenter {

    // MARK: - Properties

    weak var view: ScannerViewProtocol?
    var router: RouterProtocol?

    // MARK: - LifeCycle

    init(view: ScannerViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
}

// MARK: - ScannerPresenterProtocol

extension ScannerPresenter: ScannerPresenterProtocol {
    
}
