//
//  AppCoordinator.swift
//  Tailor
//
//  Created by Logan Allen on 2/22/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit
import Compass

protocol AppCoordinatorDelegate {
    // pass this into all view controllers!
}

// app coordinator has knowledge of view controllers

class AppCoordinator {
    
    private var app: UIApplication!

    // MARK: - Coordinators
    var routeCoordinator: RouteCoordinator!
    var databaseCoordinator: CoreDataCoordinator!
    var notificationCoordinator: NotificationCoordinator? = nil
    
    init(window: UIWindow, app: UIApplication) {
        self.app = app

        self.routeCoordinator = RouteCoordinator(coordinator: self, window: window)
        self.databaseCoordinator = CoreDataCoordinator(coordinator: self)
    }

    func initializeAfterCoreData() {
        self.notificationCoordinator = NotificationCoordinator(
            databaseService: databaseCoordinator.databaseService,
            app: self.app
        )
    }

    func start() {
        // Basic UI initialization

        let url: NSURL = NSURL(string: "\(Compass.scheme)allHabits")!
        self.navigateToRoute(url, options: nil)

        // Override point for customization after application launch.
        if(UIApplication.instancesRespondToSelector(Selector("registerUserNotificationSettings:"))) {
            // let notificationCategory:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
            // notificationCategory.identifier = "TRIGGER_CATEGORY"
            // notificationCategory .setActions([replyAction], forContext: UIUserNotificationActionContext.Default)

            // registering for the notification.
            app.registerUserNotificationSettings(
                UIUserNotificationSettings(forTypes:[.Sound, .Alert, .Badge], categories: nil)
            )
        } else {
            print("SOMETHING IS FUCKED UP")
        }
    }

    
    func navigateToRoute(url: NSURL, options: [String : AnyObject]?) -> Bool {
        return routeCoordinator.navigateToRoute(url, options: options)
    }

    /// pop the current scene to go back to the previous scene
    func popScene() -> Bool {
        return false
    }
}