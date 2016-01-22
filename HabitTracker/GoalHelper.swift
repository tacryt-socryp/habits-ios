//
//  GoalHelper.swift
//  Tailor
//
//  Created by Logan Allen on 1/20/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//


import RealmSwift

class GoalHelper {

    static let realmQueue = dispatch_queue_create("goalDB", DISPATCH_QUEUE_SERIAL)


    static func queryGoals(active: Bool) -> Results<Goal>? {
        do {
            let realm = try Realm()
            var goals = realm.objects(Goal)
            if active {
                goals = goals.filter("habits.@count > 0")
            }
            goals = goals.sorted("goalOrder")
            return goals
        } catch let err1 as NSError {
            print(err1)
            return nil
        }
    }

    static func createGoal(name: String, goalOrder: Int, habitUUIDs: [String], complete: (() -> ())? = nil) {
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
                        Goal.self,
                        value: [
                            "name": name,
                            "goalOrder": goalOrder,
                            "habits": habits
                        ]
                    )

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

    static func updateGoal(uuid: String, name: String? = nil, goalOrder: Int? = nil, habitUUIDs: [String]? = nil) {
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
                    if let p = goalOrder {
                        value.updateValue(p, forKey: "goalOrder")
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
                        Goal.self,
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

    static func deleteGoal(uuid: String) {
        dispatch_async(realmQueue) {
            autoreleasepool {
                do {
                    let realm = try Realm()
                    let goal = realm.objectForPrimaryKey(Goal.self, key: uuid)
                    realm.beginWrite()
                    if goal != nil {
                        realm.delete(goal!)
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