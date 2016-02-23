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

    static func resetLocalNotifications(dataController: DatabaseService?) {
        self.cancelLocalNotifications()

        dataController?.fetchAllTriggers { triggers in

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

    static func scheduleLocalNotification(notification: UILocalNotification) {
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
}