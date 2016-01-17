//
//  RealmHelper.swift
//  HabitTracker
//
//  Created by Logan Allen on 1/17/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import RealmSwift

class RealmHelper {
    static func writeHabit() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            autoreleasepool {
                // Get realm and table instances for this thread
                let realm = try! Realm()

                // Break up the writing blocks into smaller portions
                // by starting a new transaction
                    realm.beginWrite()

                // Add row via dictionary. Property order is ignored.
                realm.create(Habit.self, value: [
                    "name": "Running",
                    "active": true,
                    "habitOrder": 0
                ])

                // Commit the write transaction
                // to make this data available to other threads
                try! realm.commitWrite()
            }
        }
    }
}