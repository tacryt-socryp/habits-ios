//
//  HabitHelper.swift
//  HabitTracker
//
//  Created by Logan Allen on 1/17/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import RealmSwift

class HabitHelper {

    static let realmQueue = dispatch_queue_create("habitDB", DISPATCH_QUEUE_SERIAL)


    static func queryHabits() -> Results<Habit>? {
        do {
            let realm = try Realm()
            var habits = realm.objects(Habit)
            habits = habits.sorted("habitOrder")
            return habits
        } catch let err1 as NSError {
            print(err1)
            return nil
        }
    }

    static func createHabit(name: String, habitOrder: Int, goalUUID: String? = nil, complete: (() -> ())? = nil) {
        dispatch_async(realmQueue) {
            autoreleasepool {
                // Get realm and table instances for this thread
                do {
                    let realm = try Realm()
                    // Break up the writing blocks into smaller portions
                    // by starting a new transaction
                    realm.beginWrite()

                    // Add row via dictionary. Property order is ignored.
                    let habit = realm.create(
                        Habit.self,
                        value: [
                            "name": name,
                            "habitOrder": habitOrder
                        ]
                    )

                    if goalUUID != nil {
                        if let p = realm.objectForPrimaryKey(Goal.self, key: goalUUID!) {
                            var habitUUIDs = p.habits.map({ $0.uuid })
                            habitUUIDs.append(habit.uuid)
                            GoalHelper.updateGoal(p.uuid, habitUUIDs: habitUUIDs)
                        }
                    }

                    // Commit the write transaction
                    // to make this data available to other threads
                    try realm.commitWrite()
                    if let c = complete {
                        c()
                    }
                } catch let err1 as NSError {
                    print(err1)
                }
            }
        }
    }

    // Send a string, int, bool
    static func createHabits(habits: [[AnyObject]]) {
        dispatch_async(realmQueue) {
            autoreleasepool {
                // Get realm and table instances for this thread
                do {
                    let realm = try Realm()
                    // Break up the writing blocks into smaller portions
                    // by starting a new transaction
                    realm.beginWrite()

                    for value in habits {
                        if value.count > 2 {
                            let name = value[0] as! String
                            let habitOrder = value[2] as! Int

                            // Add row via dictionary. Property order is ignored.
                            realm.create(
                                Habit.self,
                                value: [
                                    "name": name,
                                    "habitOrder": habitOrder
                                ]
                            )
                        }
                    }

                    // Commit the write transaction
                    // to make this data available to other threads
                    try realm.commitWrite()
                } catch let err1 as NSError {
                    print(err1)
                }
            }
        }
    }

    static func updateHabit(uuid: String, name: String? = nil, habitOrder: Int? = nil) {
        dispatch_async(realmQueue) {
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

    static func deleteHabit(uuid: String, complete: (() -> ())? = nil) {
        dispatch_async(realmQueue) {
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
                    if let c = complete {
                        c()
                    }
                } catch let err1 as NSError {
                    print(err1)
                }
            }
        }
    }

    static func deleteAllObjects() {
        dispatch_async(realmQueue) {
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