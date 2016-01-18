//
//  PriorityHelper.swift
//  HabitTracker
//
//  Created by Logan Allen on 1/18/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import RealmSwift

class PriorityHelper {

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