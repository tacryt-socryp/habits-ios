//
//  Priority.swift
//  HabitTracker
//
//  Created by Logan Allen on 1/17/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import RealmSwift

// A Priority is a category for Habits. Health, Academics, etc.
class Priority: Object {

    dynamic var uuid = NSUUID().UUIDString
    dynamic var name = ""
    dynamic var priorityOrder = -1
    let habits = List<Habit>()


    override static func primaryKey() -> String? {
        return "uuid"
    }
    
    override static func indexedProperties() -> [String] {
        return ["priorityOrder"]
    }
}