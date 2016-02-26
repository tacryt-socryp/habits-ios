//
//  NotificationService.swift
//  Tailor
//
//  Created by Logan Allen on 2/22/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit

class NotificationCoordinator: NSObject {

    private var app: UIApplication!
    private var databaseService: DatabaseService!

    init(databaseService: DatabaseService, app: UIApplication) {
        super.init()
        self.databaseService = databaseService
        self.app = app
    }

    // MARK: - Local Notifications

    func didReceiveLocalNotification(notification: UILocalNotification) {
        // this means it is time for the user to add an entry today, and they haven't yet
        // applicationIconBadgeNumber = number of habits with needAction as true

        if let userInfo = notification.userInfo, let habitURI = userInfo["habit"] as? NSURL {
            if let habitObjectID = databaseService.persistentStoreCoordinator.managedObjectIDForURIRepresentation(habitURI) {
                databaseService.setHabitNeedsAction(habitObjectID)
                self.setIconBadgeNumber()
            }
        }
    }

    func setIconBadgeNumber() {
        // iterate through habits and set applicationIconBadgeNumber
        // TODO: Don't just iterate the number!
        var appIconBadgeNumber = 0
        databaseService.fetchAllHabits { habits in
            habits.forEach { habit in
                appIconBadgeNumber = appIconBadgeNumber + Int(habit.needsAction)
            }
            self.app.applicationIconBadgeNumber = appIconBadgeNumber
        }
    }

    func handleActionWithIdentifier(identifier: String?, forLocalNotification: UILocalNotification, completionHandler: () -> Void) {
        // this is for custom actions
    }
}