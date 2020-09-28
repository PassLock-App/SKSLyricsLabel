//
//  AppDelegate.swift
//  SKSLyricsLabelDemo
//
//  Created by sks on 2020/9/28.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.setupRootWindow()
        return true
    }
    
    func setupRootWindow() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UINavigationController(rootViewController: DemoViewController())
        self.window?.makeKeyAndVisible()
    }
    
}
