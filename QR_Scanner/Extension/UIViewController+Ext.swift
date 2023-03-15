//
//  Extensions.swift
//  QR_Scanner
//
//  Created by Sergio on 15.03.23.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
    }
}
