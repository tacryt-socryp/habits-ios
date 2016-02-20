//
//  TimeTrigger.swift
//  Tailor
//
//  Created by Logan Allen on 2/16/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import CoreData
import UIKit


class TimeTrigger: Trigger {

    var weekDaySet: Set<WeekDay>? = nil

    // format of time string is
    var dateInfo: NSDate? = nil
    var repeating: NSCalendarUnit? = nil

    struct timeDictKeys {
        static let weekDays = "weekDays"
        static let dateInfo = "dateInfo"
        static let repeatInterval = "repeatInterval"
    }


    // MARK: - Helper functions

    func startOfWeek(date: NSDate) -> NSDate {
        let calendar = NSCalendar.currentCalendar()

        let components = calendar.components([.Weekday, .Day, .Hour, .Minute], fromDate: date)
        components.day = components.day - components.weekday + 1

        // returns NSDate at start of day of start of this week
        return calendar.dateFromComponents(components)!
    }

    func nextDay(date: NSDate) -> NSDate {
        return date.dateByAddingTimeInterval(86400)
    }

    func nextWeek(date: NSDate) -> NSDate {
        return date.dateByAddingTimeInterval(86400*7)
    }

    func setDay(date: NSDate, day: WeekDay) -> NSDate {
        return date
    }

    // MARK: - Trigger functions

    override func parseFromData() {
        let dict = self.data as! NSDictionary

        if let weekDays = dict.valueForKey(timeDictKeys.weekDays) as? Set<WeekDay> {
            weekDaySet = weekDays
        }

        if let date = dict.valueForKey(timeDictKeys.dateInfo) as? NSDate {
            dateInfo = date as NSDate
        }

        if let repeatInterval = dict.valueForKey(timeDictKeys.repeatInterval) as? NSCalendarUnit {
            repeating = repeatInterval
        }
    }

    override func createLocalNotifications() -> [UILocalNotification?] {
        let notifications = [UILocalNotification?]()
        if let weekDays = weekDaySet, let storedDate = dateInfo {
            weekDays.forEach { day in
                let notification = UILocalNotification()
                notification.alertTitle = self.habit.name
                notification.alertBody = self.reminderText
                // notification.alertLaunchImage

                var userInfo = [NSObject:AnyObject]()
                userInfo.updateValue(habit.objectID.URIRepresentation(), forKey: "habit")

                notification.userInfo = userInfo

                if let repeatInterval = repeating {
                    notification.repeatInterval = repeatInterval
                }

                // set to be correct day of this week to start repeat interval
                // hour and minute should already be set
                let fireDate: NSDate = self.setDay(storedDate, day: day)
                notification.fireDate = fireDate
            }
        }
        return notifications
    }

}
