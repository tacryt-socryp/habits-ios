//
//  NotificationService.swift
//  Tailor
//
//  Created by Logan Allen on 2/23/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit

class NotificationService {

    private var app: UIApplication!
    var databaseService: DatabaseService!

    init(coordinator: CoreDataCoordinator, app: UIApplication) {
        self.app = app
        self.databaseService = coordinator.databaseService
    }

    func cancelLocalNotifications() {
        app.cancelAllLocalNotifications()
    }

    func resetLocalNotifications() {
        self.cancelLocalNotifications()

        self.databaseService.fetchAllTriggers { triggers in

            if let allTriggers = triggers {

                allTriggers.forEach { managedObject in
                    if let typeNum = managedObject.valueForKey("type") as? NSNumber,
                        let type = TriggerTypes(rawValue: typeNum.integerValue) {

                            switch type {
                            case .Time:
                                let trigger: TimeTrigger = managedObject as! TimeTrigger
                                trigger.parseFromData()
                                trigger.createLocalNotifications().forEach { notif in
                                    if let notification = notif {
                                        self.scheduleLocalNotification(notification)
                                    }
                                }
                            }

                    }
                }

            }

        }

    }

    func scheduleLocalNotification(notification: UILocalNotification) {
        app.scheduleLocalNotification(notification)
    }
}