//
//  AppDelegate.swift
//  QR_Scanner
//
//  Created by Sergio on 6.03.23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = ViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }
}
