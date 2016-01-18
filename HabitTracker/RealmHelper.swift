//
//  RealmHelper.swift
//  HabitTracker
//
//  Created by Logan Allen on 1/17/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import RealmSwift

class RealmHelper {
    static func createHabit(name: String, active: Bool, habitOrder: Int) {
        print(Realm.Configuration.defaultConfiguration.path!)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            autoreleasepool {
                // Get realm and table instances for this thread
                do {
                    let realm = try Realm()
                    // Break up the writing blocks into smaller portions
                    // by starting a new transaction
                    realm.beginWrite()

                    // Add row via dictionary. Property order is ignored.
                    realm.create(
                        Habit.self,
                        value: [
                            "name": name,
                            "active": active,
                            "habitOrder": habitOrder
                        ]
                    )

                    // Commit the write transaction
                    // to make this data available to other threads
                    do {
                        try realm.commitWrite()
                    } catch let err2 as NSError {
                        print(err2)
                    }
                } catch let err1 as NSError {
                    print(err1)
                }
            }
        }
    }
}