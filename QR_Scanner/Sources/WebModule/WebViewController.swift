//
//  WebViewController.swift
//  QR_Scanner
//
//  Created by Sergio on 11.03.23.
//

import UIKit
import WebKit

protocol WebViewControllerProtocol: AnyObject {

}

final class WebViewController: UIViewController {

    // MARK: - Properties

    var presenter: WebViewPresenterProtocol?

    var activityViewController: UIActivityViewController?
    var url = String()

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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkURL()
    }

    // MARK: - Setups

    // UIActivityViewController
    @objc func shareInfo() {
        guard let url = URL(string: url) else { return }

        getDataFromUrl(url: url) { data, _, _ in

            DispatchQueue.main.async() {
                let activityViewController = UIActivityViewController(activityItems: [data ?? ""], applicationActivities: nil)
                activityViewController.modalPresentationStyle = .fullScreen
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
    }

    private func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
        }.resume()
    }

    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .done, target: self, action: #selector(shareInfo))
    }

    // Check for Valid URL
    private func checkURL() {
        if urlChecker(url){
            let url = URL(string: url)!
            showWebsite(url)
        } else{
            //ALERT
            print("INVALID")
        }
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

    func showWebsite(_ url : URL) {
        webView.load(URLRequest(url: url))
    }
}

//MARK: - WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
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
// MARK: - WebViewControllerProtocol

extension WebViewController: WebViewControllerProtocol {

}
