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

    @NSManaged var name: String?
    @NSManaged var uuid: String?
    @NSManaged var goal: String?
    @NSManaged var order: NSNumber?
    @NSManaged var useNumDays: NSNumber?
    @NSManaged var numDays: NSNumber?
    @NSManaged var monday: NSNumber?
    @NSManaged var tuesday: NSNumber?
    @NSManaged var wednesday: NSNumber?
    @NSManaged var thursday: NSNumber?
    @NSManaged var friday: NSNumber?
    @NSManaged var saturday: NSNumber?
    @NSManaged var sunday: NSNumber?
    @NSManaged var entries: NSOrderedSet?

}