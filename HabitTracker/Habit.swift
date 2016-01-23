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
    dynamic var habitOrder = -1
    let entries = List<Entry>()


    let numDays = RealmOptional<Int>()

    dynamic var monday = false
    dynamic var tuesday = false
    dynamic var wednesday = false
    dynamic var thursday = false
    dynamic var friday = false
    dynamic var saturday = false
    dynamic var sunday = false


    override static func primaryKey() -> String? {
        return "uuid"
    }

    override static func indexedProperties() -> [String] {
        return ["habitOrder"]
    }
}