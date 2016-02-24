//
//  CoreDataCoordinator.swift
//  Tailor
//
//  Created by Logan Allen on 2/22/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import CoreData

class CoreDataCoordinator: NSObject {

    var databaseService: DatabaseService!
    private var appCoordinator: AppCoordinator!
    var isCoreDataSetup = false

    init(coordinator: AppCoordinator) {
        super.init()
        self.appCoordinator = coordinator
        self.databaseService = DatabaseService(coordinator: self)
    }

    // MARK: - iCloud Events
    func registerCoordinatorForStoreNotifications(coordinator : NSPersistentStoreCoordinator) {
        let nc : NSNotificationCenter = NSNotificationCenter.defaultCenter();

        nc.addObserver(self, selector: "handleStoresWillChange:",
            name: NSPersistentStoreCoordinatorStoresWillChangeNotification,
            object: coordinator)

        nc.addObserver(self, selector: "handleStoresDidChange:",
            name: NSPersistentStoreCoordinatorStoresDidChangeNotification,
            object: coordinator)

        nc.addObserver(self, selector: "handleStoresWillRemove:",
            name: NSPersistentStoreCoordinatorWillRemoveStoreNotification,
            object: coordinator)

        nc.addObserver(self, selector: "handleStoreChangedUbiquitousContent:",
            name: NSPersistentStoreDidImportUbiquitousContentChangesNotification,
            object: coordinator)
    }

    func handleStoresWillChange(notification: NSNotification) {
        print("will change")
        // will change occurs when iCloud is first set up, and when an account transition happens. each should be handled differently, based on userInfo in notification

        if (notification.userInfo?.indexForKey(NSAddedPersistentStoresKey) != nil) {
            // iCloud first time setup
            databaseService?.managedObjectContext.performBlock {
                self.databaseService?.managedObjectContext.reset()
            }
        } else if (notification.userInfo?.indexForKey(NSPersistentStoreUbiquitousTransitionTypeKey) != nil) {
            // iCloud account transition
            databaseService?.managedObjectContext.performBlock {
                self.databaseService?.managedObjectContext.reset()
            }
            // disable UI
            // basically go back to onboarding screen?
        }
        print(notification)
    }

    func handleStoresDidChange(notification: NSNotification) {
        print("did change")
        if (!isCoreDataSetup) {
            isCoreDataSetup = true
            appCoordinator.initializeAfterCoreData()
        }
        databaseService?.managedObjectContext.performBlock {
            self.databaseService?.managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
            NotificationController.resetLocalNotifications(self.databaseService)
            // NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.fetchTableData, object: nil)

        }
        print(notification)
    }

    func handleStoresWillRemove(notification: NSNotification) {
        print("will remove")
        print(notification)
        NotificationController.cancelLocalNotifications()
    }

    func handleStoreChangedUbiquitousContent(notification: NSNotification) {
        print("changed ubiquitous content")
        databaseService?.managedObjectContext.performBlock {
            // decide whether to merge in memory or just refetch
            self.databaseService?.managedObjectContext.mergeChangesFromContextDidSaveNotification(notification) // merge in memory
            NotificationController.resetLocalNotifications(self.databaseService)
        }
        print(notification)
    }
    
}