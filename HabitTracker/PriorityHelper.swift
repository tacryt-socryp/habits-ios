//
//  PriorityHelper.swift
//  HabitTracker
//
//  Created by Logan Allen on 1/18/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import RealmSwift

class PriorityHelper {

    static let realmQueue = dispatch_queue_create("priorityDB", DISPATCH_QUEUE_SERIAL)


    static func queryPriorities(active: Bool) -> Results<Priority>? {
        do {
            let realm = try Realm()
            var priorities = realm.objects(Priority)
            if active {
                priorities = priorities.filter("habits.@count > 0")
            }
            priorities = priorities.sorted("priorityOrder")
            return priorities
        } catch let err1 as NSError {
            print(err1)
            return nil
        }
    }

    static func createPriority(name: String, priorityOrder: Int, habitUUIDs: [String]) {
        dispatch_async(realmQueue) {
            autoreleasepool {
                do {
                    let realm = try Realm()
                    realm.beginWrite()

                    var habits = [Habit]()
                    for uuid in habitUUIDs {
                        if let habit = realm.objectForPrimaryKey(Habit.self, key: uuid) {
                            habits.append(habit)
                        }
                    }
                    realm.create(
                        Priority.self,
                        value: [
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

    static func updatePriority(uuid: String, name: String? = nil, priorityOrder: Int? = nil, habitUUIDs: [String]? = nil) {
        dispatch_async(realmQueue) {
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
                    if let hU = habitUUIDs {
                        var habits = [Habit]()
                        for uuid in hU {
                            if let habit = realm.objectForPrimaryKey(Habit.self, key: uuid) {
                                habits.append(habit)
                            }
                        }
                        value.updateValue(habits, forKey: "habits")
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
        dispatch_async(realmQueue) {
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