//
//  AlertService.swift
//  QR_Scanner
//
//  Created by Sergio on 12.03.23.
//

import UIKit

final class AlertService {

    // MARK: - Nested Types
    enum AlertType {
        case success
        case downloadError
        case error
        case cameraUnavailable
    }

    // MARK: - Properties
    static let shared = AlertService()

    // MARK: - Init
    private init() {}

    // MARK: - Methods
    func showAlert(controller: UIViewController, type: AlertType) {
        var title: String
        var message: String
        switch type {
        case .success:
            title = "Успех!"
            message = "Файл успешно загружен."
        case .downloadError:
            title = "Ошибка!"
            message = "Файл не был сохранен!"
        case .error:
            title = "Ошибка!"
            message = "Не верный адрес."
        case .cameraUnavailable:
            title = "Ошибка!"
            message = "Камера не доступна."
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        controller.present(alertController, animated: true, completion: nil)
    }
}
