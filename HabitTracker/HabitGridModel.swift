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
    
    var allHabits = ObservableArray<([Habit])>([])

    override init(coordinator: AppCoordinator) {
        super.init(coordinator: coordinator)
        databaseService = coordinator.databaseCoordinator.databaseService
        setup()
    }

    func setup() {
        if let habits = appData?.allHabits {
            allHabits.bidirectionalBindTo(habits)
            print("bound to your habits!")
        }
    }

    // MARK: - User Events
    func addTapped() {
        let habitGrid = routeCoordinator.routeEnumToURL(routesEnum.habitGrid)
        routeCoordinator.navigateToRoute(habitGrid, options: nil)
        print("add was tapped")
    }
}