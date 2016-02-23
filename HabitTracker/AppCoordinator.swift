//
//  AppCoordinator.swift
//  Tailor
//
//  Created by Logan Allen on 2/22/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit

protocol AppCoordinatorDelegate {
    // pass this into all view controllers!
}

// app coordinator has knowledge of view controllers

class AppCoordinator: CoreDataCoordinator {

    private var window: UIWindow!
    private var app: UIApplication!

    // MARK: - All View Controllers
    // TODO: Add all of them.
    private var navigationViewController: AppViewController!
    private var currentViewController: AppViewController? = nil

    // MARK: - Coordinators
    var databaseCoordinator: CoreDataCoordinator!
    var notificationCoordinator: NotificationCoordinator!
    
    init(window: UIWindow) {
        super.init()
        self.window = window
        self.app = UIApplication.sharedApplication()

        self.databaseCoordinator = CoreDataCoordinator()
        self.notificationCoordinator = NotificationCoordinator(databaseService: databaseCoordinator.databaseService, app: app)
    }

    func start() {
        // Basic UI initialization

        // TODO: Start another view controller!


//        let splitViewController = self.window!.rootViewController as! UISplitViewController
//        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
//        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        // splitViewController.delegate = self

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
    
    func transitionToScene(nextViewModel: ViewModel, intent: SceneTransitionIntent) {

    }

    /// pop the current scene to go back to the previous scene
    func popScene() -> Bool {
        return false
    }
}