//
//  AppDelegate.swift
//  Invoice Scanner
//
//  Created by Wilhelm Thieme on 02/05/2020.
//  Copyright © 2020 Sogeti Nederland B.V. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    internal var window: Window?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        ExchangeService.initialize()
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            Defaults.appVersion.set("\(version)")
        }
        
        window = Window()
        window?.rootViewController = NavigationController()
        window?.makeKeyAndVisible()
        
        return true
    }

}
