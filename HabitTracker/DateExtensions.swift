//
//  DateExtensions.swift
//  Tailor
//
//  Created by Logan Allen on 3/4/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import Foundation

public extension NSDate {
    static func startOfWeek(date: NSDate) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        calendar.timeZone = NSTimeZone.defaultTimeZone()

        let components = calendar.components([.WeekOfYear, .Weekday, .Hour, .Minute, .YearForWeekOfYear], fromDate: date)
        components.weekday = 1

        return calendar.dateFromComponents(components)!
    }

    static func previousDay(date: NSDate, numberOfDays: Int = 1) -> NSDate {
        return date.dateByAddingTimeInterval(Double(numberOfDays * -86400))
    }

    static func nextDay(date: NSDate, numberOfDays: Int = 1) -> NSDate {
        return date.dateByAddingTimeInterval(Double(numberOfDays * 86400))
    }

    static func setDay(date: NSDate, day: WeekDay) -> NSDate {
        var newDate = startOfWeek(date)

        if (day.rawValue != 0) {
            for var i = 0; i <= day.rawValue; i++ {
                newDate = nextDay(newDate)
            }
        }

        return newDate
    }

    static func getTimeZone(date: NSDate) -> NSTimeZone? {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.TimeZone], fromDate: date)
        return components.timeZone
    }
}