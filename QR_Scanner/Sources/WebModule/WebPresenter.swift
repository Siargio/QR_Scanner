//
//  WebPresenter.swift
//  QR_Scanner
//
//  Created by Sergio on 11.03.23.
//

import UIKit

protocol WebViewPresenterProtocol: AnyObject {
    var url: String { get set }
    func loadWebsite()
    func share()
}

final class WebViewPresenter: WebViewPresenterProtocol {

    // MARK: - Properties

    weak var webViewController: WebViewControllerProtocol?
    private let router: RouterProtocol?
    var url: String

    // MARK: - Init

    init(webViewController: WebViewControllerProtocol, router: RouterProtocol, url: String) {
        self.webViewController = webViewController
        self.router = router
        self.url = url
    }

    // MARK: - Setups

    func loadWebsite() {
        guard let url = URL(string: url) else { return }
        let urlRequest = URLRequest(url: url)
        webViewController?.showWebsite(URLRequest: urlRequest)
    }

    func share() {
        NetworkService.shared.getDataFromUrl(url: url) { [weak self] result in
            switch result {
            case .success(let data):
                self?.webViewController?.shareInfo(data: data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
