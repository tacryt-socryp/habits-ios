//
//  NotificationController.swift
//  Tailor
//
//  Created by Logan Allen on 2/17/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit

class NotificationController {

    static func cancelLocalNotifications() {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }

    static func resetLocalNotifications(dataController: DataController) {
        self.cancelLocalNotifications()

        dataController.fetchAllTriggers { triggers in

            if let allTriggers = triggers {

                allTriggers.forEach { trigger in
                    if let type = TriggerTypes(rawValue: trigger.type.integerValue) {

                        switch type {
                        case .Time:
                            let tT: TimeTrigger = trigger as! TimeTrigger
                            tT.parseFromData()
                            tT.createLocalNotifications().forEach { notif in
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

    static func scheduleLocalNotification(notification: UILocalNotification) {
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
}