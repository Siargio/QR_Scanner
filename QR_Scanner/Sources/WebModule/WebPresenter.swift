//
//  WebPresenter.swift
//  QR_Scanner
//
//  Created by Sergio on 11.03.23.
//

import UIKit

protocol WebViewPresenterProtocol: AnyObject {
    func shareInfo(controller: WebViewController)
}

final class WebViewPresenter: NSObject {

    // MARK: - Properties
    weak var webViewController: WebViewControllerProtocol?
    private let router: RouterProtocol?

    // MARK: - Init
    init(webViewController: WebViewControllerProtocol, router: RouterProtocol) {
        self.webViewController = webViewController
        self.router = router
    }

    // MARK: - Setups
    private func getUrl() -> String {
        guard let url = webViewController?.url else { return "error" }
        return url
    }
}

// MARK: - WebViewPresenterProtocol
extension WebViewPresenter: WebViewPresenterProtocol {
    @objc func shareInfo(controller: WebViewController) {
        guard let url = URL(string: getUrl()) else { return }

        getDataFromUrl(url: url) { data, _, _ in

            DispatchQueue.main.async() {
                let activityViewController = UIActivityViewController(activityItems: [data ?? ""], applicationActivities: nil)
                activityViewController.modalPresentationStyle = .fullScreen
                controller.present(activityViewController, animated: true, completion: nil)

                activityViewController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
                    if completed {
                        error == nil ? self.webViewController?.displaySuccessMessage() : self.webViewController?.downloadError()
                    }
                }
            }
        }
    }

    private func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
        }.resume()
    }
}
