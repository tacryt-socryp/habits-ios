//
//  CoreDataStack.swift
//  Tailor
//
//  Created by Logan Allen on 1/28/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import Foundation
import SugarRecord
import CoreData

class CoreDataStack: NSObject {

    // MARK: - Attributes

    var habits = [Habit]() {
        didSet {
            habits.forEach({
                print($0)
            })
        }
    }

    lazy var db: CoreDataDefaultStorage = {
        let store = CoreData.Store.Named("tailorDataStore")
        let bundle = NSBundle.mainBundle()
        let model = CoreData.ObjectModel.Merged([bundle])
        let defaultStorage = try! CoreDataDefaultStorage(store: store, model: model)
        return defaultStorage
    }()

    // MARK: - Private

    func createHabit(name: String, order: NSNumber, goal: String? = nil,
                    numDays: NSNumber = -1, useNumDays: Bool = true,
                    monday: Bool = false, tuesday: Bool = false, wednesday: Bool = false,
                    thursday: Bool = false, friday: Bool = false, saturday: Bool = false,
                    sunday: Bool = false
        ) {
        db.operation { (context, save) -> Void in
            let newHabit: Habit = try! context.create()
            newHabit.name = name
            newHabit.uuid = NSUUID().UUIDString
            newHabit.order = order
            newHabit.useNumDays = useNumDays

            if useNumDays {
                newHabit.numDays = numDays
            } else {
                newHabit.monday = monday
                newHabit.tuesday = tuesday
                newHabit.wednesday = wednesday
                newHabit.thursday = thursday
                newHabit.friday = friday
                newHabit.saturday = saturday
                newHabit.sunday = sunday
            }

            save()
        }
    }

    func updateHabit(uuid: String, name: String? = nil, order: NSNumber? = nil, goal: String? = nil,
                    numDays: NSNumber? = nil, useNumDays: Bool? = nil,
                    monday: Bool? = nil, tuesday: Bool? = nil, wednesday: Bool? = nil,
                    thursday: Bool? = nil, friday: Bool? = nil, saturday: Bool? = nil,
                    sunday: Bool? = nil
        ) {
        db.operation { (context, save) -> Void in
            let habit: Habit? = try! context.request(Habit.self).filteredWith("uuid", equalTo: uuid).fetch().first
            if let habit = habit {
                if name != nil {
                    habit.name = name
                }
                if order != nil {
                    habit.order = order
                }
                if useNumDays != nil {
                    habit.useNumDays = useNumDays
                }
                if numDays != nil {
                    habit.numDays = numDays
                }

                if monday != nil {
                    habit.monday = monday
                }
                if tuesday != nil {
                    habit.tuesday = tuesday
                }
                if wednesday != nil {
                    habit.wednesday = wednesday
                }
                if thursday != nil {
                    habit.thursday = thursday
                }
                if friday != nil {
                    habit.friday = friday
                }
                if saturday != nil {
                    habit.saturday = saturday
                }
                if sunday != nil {
                    habit.sunday = sunday
                }

                save()
            }
        }
    }

    func removeHabit(uuid: String) {
        db.operation { (context, save) -> Void in
            let habit: Habit? = try! context.request(Habit.self).filteredWith("uuid", equalTo: uuid).fetch().first
            if let habit = habit {
                try! context.remove([habit])
                save()
            }
        }
    }
}
