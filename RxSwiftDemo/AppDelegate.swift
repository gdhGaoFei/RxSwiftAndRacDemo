//
//  AppDelegate.swift
//  RxSwiftDemo
//
//  Created by 华&梅 on 2020/12/7.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let wd = UIWindow(frame: UIScreen.main.bounds)
        self.window = wd
        wd.makeKeyAndVisible()
        
        /*
        let root_vc = UIStoryboard.init(name: "LaunchScreen", bundle: nil).instantiateViewController(withIdentifier: "ViewController")
        wd.rootViewController = root_vc
        */
        
        wd.rootViewController = UINavigationController(rootViewController: ViewController())
        
        return true
    }
}

