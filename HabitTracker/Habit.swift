//
//  Habit.swift
//  HabitTracker
//
//  Created by Logan Allen on 1/17/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import RealmSwift

// A Habit is a trackable part of your life that can be searched, filtered, or sorted by Priorities.
class Habit: Object {

    dynamic var uuid = NSUUID().UUIDString
    dynamic var name = ""
    dynamic var active = false
    dynamic var habitOrder = -1


    override static func primaryKey() -> String? {
        return "uuid"
    }

    override static func indexedProperties() -> [String] {
        return ["habitOrder"]
    }
}