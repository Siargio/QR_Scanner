//
//  WebViewController.swift
//  QR_Scanner
//
//  Created by Sergio on 11.03.23.
//

import UIKit
import WebKit

// MARK: - Protocol

protocol WebViewControllerProtocol: AnyObject {
    func showWebsite(URLRequest : URLRequest)
    func shareInfo(data: Any)
}

// MARK: - Class

final class WebViewController: UIViewController, WebViewControllerProtocol {

    // MARK: - Properties

    var presenter: WebViewPresenterProtocol?

    //MARK: - UIElements

    private lazy var webView: WKWebView = {
        var webView = WKWebView()
        let webConfig = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfig)
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressViewStyle = .bar
        progressView.backgroundColor = .systemBlue
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()

    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupHierarchy()
        setupLayout()
        presenter?.loadWebsite()
    }

    // MARK: - Setups
    
    func showWebsite(URLRequest : URLRequest) {
        webView.load(URLRequest)
    }

    @objc private func share() {
        presenter?.share()
    }

    func shareInfo(data: Any) {
        let activityViewController = UIActivityViewController(activityItems: [data], applicationActivities: nil)

        activityViewController.completionWithItemsHandler = { _, success, _, error in
            if success {
                self.showAlert(title: Strings.alertTitleSuccess, message: Strings.alertMessageSuccess)
            }
            if error != nil {
                self.showAlert(title: Strings.alertErrorTitleDownload, message: Strings.alertErrorMessageDownload)
            }
        }
        DispatchQueue.main.async() {
            self.present(activityViewController, animated: true, completion: nil)
        }
    }

    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: Strings.squareImage,
            style: .done,
            target: self,
            action: #selector(share))
    }

    private func setupHierarchy() {
        view.addSubview(webView)
        view.addSubview(progressView)
    }
}

//MARK: - WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == Strings.keyPath {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
    }
}

//MARK: - Constraint

private extension WebViewController {
    private func setupLayout() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

// MARK: - Appearance

private extension WebViewController {
    private enum Strings {
        static let squareImage = UIImage(systemName: "square.and.arrow.up")
        static let keyPath = "estimatedProgress"
        static let alertActionTitle = "Ok"
        static let alertTitleSuccess = "Успех!"
        static let alertMessageSuccess = "Файл сохранен."
        static let alertErrorTitleDownload = "Ошибка!"
        static let alertErrorMessageDownload = "Ошибка сохранения."
    }
}
