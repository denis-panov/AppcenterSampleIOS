//
//  AppDelegate.swift
//  AppcenterIOS
//
//  Created by Administrator on 7/19/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import AppCenterPush
import AppCenterDistribute

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,  MSCrashesDelegate, MSDistributeDelegate, MSPushDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("Test XCode Beta")
        MSAppCenter.setLogLevel(.verbose)
        MSPush.setDelegate(self)//Not implemented
        MSDistribute.setDelegate(self)
        #if DEBUG
        MSAppCenter.start("7f919a6e-42e1-4ca8-8e4b-8f13d242fa2c", withServices: [MSAnalytics.self, MSCrashes.self, MSPush.self])
        #else
        MSAppCenter.start("7f919a6e-42e1-4ca8-8e4b-8f13d242fa2c", withServices: [MSAnalytics.self, MSCrashes.self, MSDistribute.self, MSPush.self])
        #endif
        return true
    }

    func push(_ push: MSPush!, didReceive pushNotification: MSPushNotification!) {
        let title: String = pushNotification.title ?? ""
        var message: String = pushNotification.message ?? ""
        var customData: String = ""
        for item in pushNotification.customData {
            customData =  ((customData.isEmpty) ? "" : "\(customData), ") + "\(item.key): \(item.value)"
        }
        if (UIApplication.shared.applicationState == .background) {
            NSLog("Notification received in background, title: \"\(title)\", message: \"\(message)\", custom data: \"\(customData)\"");
        } else {
            message =  message + ((customData.isEmpty) ? "" : "\n\(customData)")
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
            
            // Show the alert controller.
            self.window?.rootViewController?.present(alertController, animated: true)
        }
    }
    
    func distribute(_ distribute: MSDistribute!, releaseAvailableWith details: MSReleaseDetails!) -> Bool {
        
        // Your code to present your UI to the user, e.g. an UIAlertController.
        let alertController = UIAlertController(title: "Update available.",
                                                message: "Do you want to update?",
                                                preferredStyle:.alert)
        
        alertController.addAction(UIAlertAction(title: "Update", style: .cancel) {_ in
            MSDistribute.notify(.update)
        })
        
        alertController.addAction(UIAlertAction(title: "Postpone", style: .default) {_ in
            MSDistribute.notify(.postpone)
        })
        
        // Show the alert controller.
        self.window?.rootViewController?.present(alertController, animated: true)
        return true;
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

