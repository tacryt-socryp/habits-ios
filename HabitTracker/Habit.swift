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
    dynamic var name = ""
    dynamic var active = false
    dynamic var habitOrder = -1

    override static func indexedProperties() -> [String] {
        return ["habitOrder"]
    }

    required init() {
        super.init()
    }

    init(name: String, active: Bool, habitOrder: Int) {
        super.init()

        self.name = name
        self.active = active
        self.habitOrder = habitOrder
    }
}