//
//  CreateHabitModel.swift
//  Tailor
//
//  Created by Logan Allen on 4/1/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import Bond
import CoreData
import Eureka

class CreateHabitModel: ViewModel {
    var databaseService: DatabaseService!

    override init(coordinator: AppCoordinator) {
        super.init(coordinator: coordinator)
        databaseService = coordinator.databaseCoordinator!.databaseService
    }

    func setup() {

    }

    func writeHabit(form: Form) {
        let values = form.values()
        let name = values[createRowNames.nameRow] as! String

        let weekDays: Set<WeekDay>? = values[createRowNames.weekDaysRow] as? Set<WeekDay>

        databaseService.insertHabit(name, weekDays: weekDays)
    }

}