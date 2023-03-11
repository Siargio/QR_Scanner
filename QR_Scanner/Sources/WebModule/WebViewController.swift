//
//  WebViewController.swift
//  QR_Scanner
//
//  Created by Sergio on 11.03.23.
//

import UIKit

protocol WebViewControllerProtocol: AnyObject {

}

final class WebViewController: UIViewController {

    // MARK: - Properties

    var presenter: WebViewPresenterProtocol?
}

// MARK: - WebViewControllerProtocol

extension WebViewController: WebViewControllerProtocol {

}
