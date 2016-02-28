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

    @NSManaged var monday: NSNumber?
    @NSManaged var tuesday: NSNumber?
    @NSManaged var wednesday: NSNumber?
    @NSManaged var thursday: NSNumber?
    @NSManaged var friday: NSNumber?
    @NSManaged var saturday: NSNumber?
    @NSManaged var sunday: NSNumber?

    @NSManaged var entries: Array<Entry>
    @NSManaged var triggers: Array<NSManagedObject>

    @NSManaged var needsAction: NSNumber

    func sortEntries() {
        entries.sortInPlace {
            return $0.date.compare($1.date).rawValue > 0
        }
    }

    var isTodayComplete: Bool {
        if let lastObject = entries.last {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            let todayString = formatter.stringFromDate(NSDate())
            let mostRecentEntryString = formatter.stringFromDate(lastObject.date)
            return todayString == mostRecentEntryString
        }
        return false
    }

}