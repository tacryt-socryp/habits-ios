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
            var i = 0
            while i <= day.rawValue {
                newDate = nextDay(newDate)
                i += 1
            }
        }

        return newDate
    }

    static func sameDay(date: NSDate, otherDate: NSDate) -> Bool {
        let calendar = NSCalendar.currentCalendar()
        calendar.timeZone = NSTimeZone.defaultTimeZone()

        let dateComponent = calendar.components([.WeekOfYear, .Weekday, .TimeZone, .YearForWeekOfYear], fromDate: date)
        let dateComponent2 = calendar.components([.WeekOfYear, .Weekday, .TimeZone, .YearForWeekOfYear], fromDate: otherDate)

        return calendar.dateFromComponents(dateComponent)!.timeIntervalSince1970 ==
            calendar.dateFromComponents(dateComponent2)!.timeIntervalSince1970
    }

    static func getTimeZone(date: NSDate) -> NSTimeZone? {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.TimeZone], fromDate: date)
        return components.timeZone
    }
}