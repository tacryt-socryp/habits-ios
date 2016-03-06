//
//  AppDataService.swift
//  Tailor
//
//  Created by Logan Allen on 2/25/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import CoreData
import Bond

class AppDataService {
    private static var appDataService: AppDataService? = nil
    var coordinator: AppCoordinator!
    var databaseService: DatabaseService!

    // Bond Data
    var allHabits = ObservableArray<Habit>([])
    var allTriggers = ObservableArray<NSManagedObject>([])

    var currentHabit = Observable<Habit?>(nil)
    var currentHabitEntries = ObservableArray<Entry>([])
    var currentHabitTriggers = ObservableArray<NSManagedObject>([])


    // MARK: - Lifecycle

    init(coordinator: AppCoordinator, databaseService: DatabaseService) {
        self.coordinator = coordinator
        self.databaseService = databaseService
        allHabits.observe({ event in
            switch event.operation {
            case .Insert(let elements, let fromIndex):
                print("Inserted \(elements) from index \(fromIndex)")
            case .Remove(let range):
                print("Removed elements in range \(range)")
            case .Update(let elements, let fromIndex):
                print("Updated \(elements) from index \(fromIndex)")
            case .Reset(let array):
                print("Array was reset to \(array)")
            case .Batch(let operations):
                print("Operations \(operations) were perform on the array")
            }
        })

        currentHabit.observe { habit in
            if let habit = habit {
                self.diffOnRefreshedResults(newCurrHabitEntries: habit.orderedEntries)
                self.diffOnRefreshedResults(newCurrHabitTriggers: habit.orderedTriggers)
            }
        }

        /*allTriggers.observe({ event in
            print("allTriggers is now: \(event.sequence)")
            switch event.operation {
            case .Insert(let elements, let fromIndex):
                print("Inserted \(elements) from index \(fromIndex)")
            case .Remove(let range):
                print("Removed elements in range \(range)")
            case .Update(let elements, let fromIndex):
                print("Updated \(elements) from index \(fromIndex)")
            case .Reset(_):
                self.coordinator.databaseCoordinator?.shouldResetLocalNotifications()
            case .Batch(let operations):
                print("Operations \(operations) were perform on the array")
            }
        })*/
    }

    func diffOnRefreshedResults(newAllHabits: [Habit]? = nil, newAllTriggers: [NSManagedObject]? = nil,
            newCurrHabitEntries: [Entry]? = nil, newCurrHabitTriggers: [NSManagedObject]? = nil) {
        if let newAllHabits = newAllHabits {
            self.allHabits.diffInPlace(newAllHabits)
        }
        if let newAllTriggers = newAllTriggers {
            self.allTriggers.diffInPlace(newAllTriggers)
        }
        if let newCurrHabitEntries = newCurrHabitEntries {
            self.currentHabitEntries.diffInPlace(newCurrHabitEntries)
        }
        if let newCurrHabitTriggers = newCurrHabitTriggers {
            self.currentHabitTriggers.diffInPlace(newCurrHabitTriggers)
        }
    }

    // MARK: Instantiation and retrieval

    static func getAppDataService(callback: (AppDataService? -> ()), coordinator: AppCoordinator? = nil, databaseService: DatabaseService? = nil) {
        if let c = coordinator, let dbs = databaseService {
            appDataService = AppDataService(coordinator: c, databaseService: dbs)
        }
        callback(appDataService)
    }
}