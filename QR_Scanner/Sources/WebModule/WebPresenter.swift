//
//  WebPresenter.swift
//  QR_Scanner
//
//  Created by Sergio on 11.03.23.
//

import UIKit

protocol WebViewPresenterProtocol: AnyObject {

}

final class WebViewPresenter: NSObject {

    // MARK: - Properties

    weak var view: WebViewControllerProtocol?
    private let router: RouterProtocol?

    // MARK: - LifeCycle

    init(view: WebViewControllerProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
}

// MARK: - WebViewPresenterProtocol

extension WebViewPresenter: WebViewPresenterProtocol {
    
}
