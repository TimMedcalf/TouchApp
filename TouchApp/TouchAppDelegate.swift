//
//  TouchAppDelegate.swift
//  TouchApp
//
//  Created by Tim Medcalf on 18/01/2020.
//  Copyright © 2020 ErgoThis Ltd. All rights reserved.
//

import Foundation
import UIKit
import Firebase

@UIApplicationMain
class TouchAppDelegate: UIResponder, UIApplicationDelegate {

    fileprivate func clearCache() {
        do {
            if let path = TCHAppManager.sharedInstance()?.cacheFolder {
                let fileList = try FileManager.default.contentsOfDirectory(atPath: path)
                for file in fileList {
                    try FileManager.default.removeItem(atPath: file)
                }
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        ////*******
        //#warning cache removal for testing
        clearCache()
        ////*******
        
//        //clear the cache out whenever it's a new version - allows us to change data formats without worrying
//        //about whatever is stored already on the device
        let def = UserDefaults.standard
        let ver: String? = def.string(forKey: "Version")
        let curVer: String = Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String ?? ""

        if ver == nil {
          //anything we want to run only once for the app?
            def.set(curVer, forKey:"Version")
        } else if let ver = ver, ver.compare(curVer) != .orderedSame {
            //Run once-per-upgrade code, if any
            // DDLogInfo(@"Initialisation for version %@", CurVer);
            print("Initialisation for version \(curVer)")
            //clear the cache folder!
            clearCache()
            def.set(curVer, forKey:"Version")
        }

        //load the image resource stuff...
        TJMImageResourceManager.sharedInstance()

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}
