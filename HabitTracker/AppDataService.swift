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
    var allHabits = ObservableArray<([Habit])>([])
    var currentHabit = Observable<Habit?>(nil)
    var allTriggers = ObservableArray<[NSManagedObject]>([])


    // MARK: - Lifecycle

    init(coordinator: AppCoordinator, databaseService: DatabaseService) {
        self.coordinator = coordinator
        self.databaseService = databaseService
    }

    // MARK: Instantiation and retrieval

    static func getAppDataService(callback: (AppDataService? -> ()), coordinator: AppCoordinator? = nil, databaseService: DatabaseService? = nil) {
        if let c = coordinator, let dbs = databaseService {
            appDataService = AppDataService(coordinator: c, databaseService: dbs)
            appDataService?.allHabits.observe({ event in
                print(event)
            })
        }
        callback(appDataService)
    }
}