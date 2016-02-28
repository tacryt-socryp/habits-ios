//
//  HabitGridModel.swift
//  Tailor
//
//  Created by Logan Allen on 2/22/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import Bond

class HabitGridModel: ViewModel {
    var databaseService: DatabaseService!
    var numTap: Int = 0
    
    var allHabits = ObservableArray<(Habit)>([])

    override init(coordinator: AppCoordinator) {
        super.init(coordinator: coordinator)
        databaseService = coordinator.databaseCoordinator!.databaseService
    }

    func setup() {
        appData?.allHabits.bidirectionalBindTo(self.allHabits)
    }

    // MARK: - User Events
    func addTapped() {
        // let habitGrid = routeCoordinator.routeEnumToURL(routesEnum.habitGrid)
        // routeCoordinator.navigateToRoute(habitGrid, options: nil)

        databaseService.insertHabit("Running", weekDays: Set<WeekDay>(arrayLiteral: WeekDay.Monday, WeekDay.Tuesday))
    }
}