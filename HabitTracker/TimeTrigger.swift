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
        calendar.timeZone = NSTimeZone.defaultTimeZone()

        let components = calendar.components([.WeekOfYear, .Weekday, .Hour, .Minute, .YearForWeekOfYear], fromDate: date)
        components.weekday = 1

        return calendar.dateFromComponents(components)!
    }

    func nextDay(date: NSDate) -> NSDate {
        return date.dateByAddingTimeInterval(86400)
    }

    func setDay(date: NSDate, day: WeekDay) -> NSDate {
        var newDate = startOfWeek(date)

        if (day.rawValue != 0) {
            for var i = 0; i <= day.rawValue; i++ {
                newDate = nextDay(newDate)
            }
        }

        return newDate
    }

    func getTimeZone(date: NSDate) -> NSTimeZone? {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.TimeZone], fromDate: date)
        return components.timeZone
    }

    // MARK: - Trigger functions

    override func parseFromData() {
        let dict = self.data as! NSDictionary

        if let remindText = dict.valueForKey(dictKeys.reminderText) as? String {
            reminderText = remindText
        }

        if let weekDays = dict.valueForKey(timeDictKeys.weekDays) as? NSSet {
            weekDaySet = Set<WeekDay>()
            (weekDays.allObjects as! [NSNumber]).forEach { num in
                weekDaySet?.insert(WeekDay(rawValue: num as Int)!)
            }
        }

        if let date = dict.valueForKey(timeDictKeys.dateInfo) as? NSDate {
            dateInfo = date as NSDate
        }

        if let repeatInterval = dict.valueForKey(timeDictKeys.repeatInterval) as? UInt {
            repeating = NSCalendarUnit(rawValue: repeatInterval)
        }
    }

    override func createLocalNotifications() -> [UILocalNotification?] {
        var notifications = [UILocalNotification?]()
        if let weekDays = weekDaySet, let storedDate = dateInfo {
            notifications = Array(weekDays).map { day in
                let notification = UILocalNotification()
                notification.alertTitle = String(self.habit.name)
                notification.alertBody = self.reminderText != nil ? String(self.reminderText!) : ""
                // notification.alertLaunchImage = 

                var userInfo = [NSObject:AnyObject]()
                userInfo.updateValue(habit.objectID.URIRepresentation().absoluteString, forKey: "habit")

                notification.userInfo = userInfo

                if let repeatInterval = repeating {
                    notification.repeatInterval = repeatInterval
                }

                // set to be correct day of this week to start repeat interval
                // hour and minute should already be set
                let fireDate: NSDate = self.setDay(storedDate, day: day)
                
                notification.fireDate = fireDate
                notification.timeZone = self.getTimeZone(fireDate)
                notification.applicationIconBadgeNumber = 1
                return notification
            }
        }
        return notifications
    }

}
