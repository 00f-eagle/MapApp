//
//  AppDelegate.swift
//  MapApp
//
//  Created by Kirill Selivanov on 20.08.2020.
//  Copyright © 2020 Kirill+Gleb. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MapViewController()
        window?.makeKeyAndVisible()
        return true
    }

}

