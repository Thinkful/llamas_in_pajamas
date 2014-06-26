//
//  AppDelegate.swift
//  Unit1
//
//  Copyright (c) 2014 Thinkful. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        // Override point for customization after application launch.
        
        Llama.loadAssets()
        Lion.loadAssets()
        Pyjama.loadAssets()

        return true
    }
}

