//
//  Habit.swift
//  Tailor
//
//  Created by Logan Allen on 1/29/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import Foundation
import CoreData


class Habit: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var order: NSNumber
    @NSManaged var useNumDays: NSNumber?

    @NSManaged var numDays: NSNumber?
    @NSManaged var monday: NSNumber?
    @NSManaged var tuesday: NSNumber?
    @NSManaged var wednesday: NSNumber?
    @NSManaged var thursday: NSNumber?
    @NSManaged var friday: NSNumber?
    @NSManaged var saturday: NSNumber?
    @NSManaged var sunday: NSNumber?
    @NSManaged var entries: NSArray?

    func sortEntries() {
        let mutableEntries = entries?.mutableCopy() as? NSMutableArray

        mutableEntries?.sortUsingComparator({
            (($0 as! Entry).date ).compare(($1 as! Entry).date)
        })
        entries = mutableEntries
    }

    var isTodayComplete: Bool {
        if let e = entries {
            if let lastObject = e.lastObject as? Entry {
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy.MM.dd"
                let todayString = formatter.stringFromDate(NSDate())
                print(todayString)
                let mostRecentEntryString = formatter.stringFromDate(lastObject.date)
                print(mostRecentEntryString)
                return todayString == mostRecentEntryString
            }
        }
        return false
    }

}