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
    var url: String { get set }
}

// MARK: - Class
final class WebViewController: UIViewController, WebViewControllerProtocol {

    // MARK: - Constants
    private enum Strings {
        static let squareImage = UIImage(systemName: "square.and.arrow.up")
        static let keyPath = "estimatedProgress"
        static let forKey = "estimatedProgress"
    }

    // MARK: - Properties
    var presenter: WebViewPresenterProtocol?
    var url: String

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

    //MARK: - Init
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupHierarchy()
        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkURL()
    }

    // MARK: - Setups
    @objc func shareInfo() {
        let controller = self
        presenter?.shareInfo(controller: controller)
    }

    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: Strings.squareImage,
            style: .done,
            target: self,
            action: #selector(shareInfo))
    }

    // Check for Valid URL
    private func checkURL() {
        guard let webURL = URL(string: url) else { return }
        urlChecker(url) ? showWebsite(webURL) : print("INVALID Reference")
    }

    private func urlChecker (_ urlString: String) -> Bool {
        if let url = NSURL(string: urlString) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
        return false
    }

    private func setupHierarchy() {
        view.addSubview(webView)
        view.addSubview(progressView)
    }

    private func showWebsite(_ url : URL) {
        webView.load(URLRequest(url: url))
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
extension WebViewController {
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
