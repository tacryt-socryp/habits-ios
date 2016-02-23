//
//  AppDelegate.swift
//  HabitTracker
//
//  Created by Logan Allen on 1/17/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private lazy var appCoordinator: AppCoordinator = {
        return AppCoordinator(window: self.window!)
    }()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Set up window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)

        // Pass off initialization to coordinator
        appCoordinator.start()

        return true
    }


    // MARK: - Local Notifications

    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        appCoordinator.notificationCoordinator.didReceiveLocalNotification(notification)
    }

    func application(application: UIApplication, handleActionWithIdentifier identifier: String?,
        forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        appCoordinator.notificationCoordinator.handleActionWithIdentifier(identifier, forLocalNotification: notification, completionHandler: completionHandler)
    }

}
