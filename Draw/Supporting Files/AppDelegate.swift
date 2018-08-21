//
//  AppDelegate.swift
//  Draw
//
//  Created by Homero Oliveira on 03/07/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        window = UIWindow(frame: UIScreen.main.bounds)

        let mainViewController = RoomsViewController()

        let navigationController = UINavigationController(rootViewController: mainViewController)
        navigationController.navigationBar.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationController.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        FirebaseApp.configure()

        return true
    }

}

