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
    var routeCoordinator: RouteCoordinator? = nil
    var databaseCoordinator: CoreDataCoordinator? = nil
    var notificationCoordinator: NotificationCoordinator? = nil
    
    init(window: UIWindow, app: UIApplication) {
        self.app = app

        self.routeCoordinator = RouteCoordinator(coordinator: self, window: window)
        self.databaseCoordinator = CoreDataCoordinator(coordinator: self, app: self.app)
    }

    func initializeAfterCoreData() {
        self.notificationCoordinator = NotificationCoordinator(
            databaseService: self.databaseCoordinator!.databaseService,
            app: self.app
        )
    }

    func start() {
        // Basic UI initialization

        app.statusBarStyle = .LightContent
        let url = routeCoordinator!.routeEnumToURL(routesEnum.habitGrid)
        routeCoordinator!.navigateToRoute(url, options: nil)

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
            print("we don't have the notifications permission")
        }
    }

    /// pop the current scene to go back to the previous scene
    func popScene() -> Bool {
        return false
    }
}