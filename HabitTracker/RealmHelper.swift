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
                    try realm.commitWrite()
                } catch let err1 as NSError {
                    print(err1)
                }
            }
        }
    }

    static func updateHabit(uuid: String, name: String?, active: Bool?, habitOrder: Int?) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            autoreleasepool {
                // Get realm and table instances for this thread
                do {
                    let realm = try Realm()
                    // Break up the writing blocks into smaller portions
                    // by starting a new transaction
                    realm.beginWrite()

                    // Add row via dictionary. Property order is ignored.
                    var value = [String:AnyObject]()
                    value.updateValue(uuid, forKey: "uuid")

                    if let n = name {
                        value.updateValue(n, forKey: "name")
                    }
                    if let a = active {
                        value.updateValue(a, forKey: "active")
                    }
                    if let h = habitOrder {
                        value.updateValue(h, forKey: "habitOrder")
                    }

                    realm.create(
                        Habit.self,
                        value: value,
                        update: true
                    )

                    try realm.commitWrite()
                } catch let err1 as NSError {
                    print(err1)
                }
            }
        }
    }

    static func deleteHabit(uuid: String) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            autoreleasepool {
                do {
                    let realm = try Realm()
                    let habit = realm.objectForPrimaryKey(Habit.self, key: uuid)
                    realm.beginWrite()
                    if habit != nil {
                        realm.delete(habit!)
                    } else {
                        print("habit was nil")
                    }

                    try realm.commitWrite()
                } catch let err1 as NSError {
                    print(err1)
                }
            }
        }
    }

    static func createPriority(uuid: String, name: String, priorityOrder: Int, habits: [Habit]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            autoreleasepool {
                do {
                    let realm = try Realm()
                    realm.beginWrite()

                    realm.create(
                        Priority.self,
                        value: [
                            "uuid": uuid,
                            "name": name,
                            "priorityOrder": priorityOrder,
                            "habits": habits
                        ]
                    )

                    try realm.commitWrite()
                } catch let err1 as NSError {
                    print(err1)
                }
            }
        }
    }

    static func updatePriority(uuid: String, name: String?, priorityOrder: Int?, habits: [Habit]?) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            autoreleasepool {
                do {
                    let realm = try Realm()
                    realm.beginWrite()

                    var value = [String:AnyObject]()
                    value.updateValue(uuid, forKey: "uuid")

                    if let n = name {
                        value.updateValue(n, forKey: "name")
                    }
                    if let p = priorityOrder {
                        value.updateValue(p, forKey: "priorityOrder")
                    }
                    if let h = habits {
                        value.updateValue(h, forKey: "habits")
                    }

                    realm.create(
                        Priority.self,
                        value: value,
                        update: true
                    )

                    try realm.commitWrite()
                } catch let err1 as NSError {
                    print(err1)
                }
            }
        }
    }

    static func deletePriority(uuid: String) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            autoreleasepool {
                do {
                    let realm = try Realm()
                    let priority = realm.objectForPrimaryKey(Priority.self, key: uuid)
                    realm.beginWrite()
                    if priority != nil {
                        realm.delete(priority!)
                    } else {
                        print("habit was nil")
                    }

                    try realm.commitWrite()
                } catch let err1 as NSError {
                    print(err1)
                }
            }
        }
    }

    static func deleteAllObjects() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            autoreleasepool {
                do {
                    let realm = try Realm()
                    realm.beginWrite()
                    realm.deleteAll()
                    try realm.commitWrite()
                } catch let err1 as NSError {
                    print(err1)
                }
            }
        }
    }
}