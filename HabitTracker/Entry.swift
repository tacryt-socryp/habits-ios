//
//  Entry.swift
//  Tailor
//
//  Created by Logan Allen on 1/23/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import RealmSwift

// A Priority is a category for Habits. Health, Academics, etc.
class Entry: Object {

    dynamic var date = NSDate()
    dynamic var note = ""

    override static func primaryKey() -> String? {
        return "date"
    }
}