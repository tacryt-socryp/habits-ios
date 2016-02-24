//
//  AppDelegate.swift
//  HabitTracker
//
//  Created by Logan Allen on 1/17/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit
import CoreData
import Compass

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var app: UIApplication?
    private lazy var appCoordinator: AppCoordinator = {
        return AppCoordinator(window: self.window!, app: self.app!)
    }()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Set up Compass
        Compass.scheme = "compass"

        // Set up window
        // window = UIWindow(frame: UIScreen.mainScreen().bounds)
        app = application
        appCoordinator.start()

        // Pass off initialization to coordinator
        return true
    }


    // MARK: - Compass
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        return appCoordinator.navigateToRoute(url, options: options)
    }


    // MARK: - Local Notifications

    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        appCoordinator.notificationCoordinator?.didReceiveLocalNotification(notification)
    }

    func application(application: UIApplication, handleActionWithIdentifier identifier: String?,
        forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        appCoordinator.notificationCoordinator?.handleActionWithIdentifier(identifier, forLocalNotification: notification, completionHandler: completionHandler)
    }

}
