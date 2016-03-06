//
//  CoreDataCoordinator.swift
//  Tailor
//
//  Created by Logan Allen on 2/22/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit
import CoreData
import Bond

var fetchRequestTemplates = [String : NSFetchRequest]()

class CoreDataCoordinator: NSObject {

    var databaseService: DatabaseService!
    var notificationService: NotificationService!

    private var appCoordinator: AppCoordinator!

    var isCoreDataSetup = false
    // where app data is stored!
    var appDataService: AppDataService!

    init(coordinator: AppCoordinator, app: UIApplication) {
        super.init()
        self.appCoordinator = coordinator
        self.databaseService = DatabaseService(coordinator: self)

        self.notificationService = NotificationService(coordinator: self, app: app)
        AppDataService.getAppDataService({ aDS in
            self.appDataService = aDS
        }, coordinator: coordinator, databaseService: self.databaseService)
    }

    func shouldResetLocalNotifications() {
        self.notificationService.resetLocalNotifications()
    }

    func refreshAppData() {
        self.databaseService.fetchAllHabits { habits in
            self.appDataService.diffOnRefreshedResults(habits)
        }

        self.databaseService.fetchAllTriggers { triggers in
            // print(triggers)
            self.appDataService.diffOnRefreshedResults(newAllTriggers: triggers)
        }
    }

    // MARK: - iCloud Events
    func registerCoordinatorForStoreNotifications(coordinator : NSPersistentStoreCoordinator, objectContext: NSManagedObjectContext) {
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

        nc.addObserver(self, selector: "handleObjectContextDidChange:",
            name: NSManagedObjectContextObjectsDidChangeNotification, object: objectContext)
    }

    func handleStoresWillChange(notification: NSNotification) {
        print("will change")
        // will change occurs when iCloud is first set up, and when an account transition happens. each should be handled differently, based on userInfo in notification

        if (notification.userInfo?.indexForKey(NSAddedPersistentStoresKey) != nil) {
            // iCloud first time setup
            databaseService.managedObjectContext.performBlock {
                self.databaseService.managedObjectContext.reset()
            }
        } else if (notification.userInfo?.indexForKey(NSPersistentStoreUbiquitousTransitionTypeKey) != nil) {
            // iCloud account transition
            databaseService.managedObjectContext.performBlock {
                self.databaseService.managedObjectContext.reset()
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
        databaseService.managedObjectContext.performBlock {
            self.databaseService.managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
            self.notificationService.resetLocalNotifications()
            self.refreshAppData()
            // NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.fetchTableData, object: nil)

        }
        print(notification)
    }

    func handleStoresWillRemove(notification: NSNotification) {
        print("will remove")
        print(notification)
        notificationService.cancelLocalNotifications()
    }

    func handleStoreChangedUbiquitousContent(notification: NSNotification) {
        print("changed ubiquitous content")
        databaseService.managedObjectContext.performBlock {
            // decide whether to merge in memory or just refetch
            self.databaseService.managedObjectContext.mergeChangesFromContextDidSaveNotification(notification) // merge in memory
            self.notificationService.resetLocalNotifications()
        }
        print(notification)
    }

    func handleObjectContextDidChange(notification: NSNotification) {
        print("changed object context")
        self.refreshAppData()
    }
    
}