//
//  SingleHabitModel.swift
//  Tailor
//
//  Created by Logan Allen on 3/4/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import Bond
import CoreData

// cards all go in one array
// different types of cards can have different types of data sources
// data sources should be observable
// different types of cards should inherit

class SingleHabitModel: ViewModel {
    var databaseService: DatabaseService!

    var currentHabit = Observable<Habit?>(nil)
    var allCards = ObservableArray<CardData>()

    // bind a bunch of graphs and data analysis to entries
    var entries = ObservableArray<Entry>([])

    // for last week entries graph card
    var lastWeekEntries = ObservableArray<Entry>([])

    // bind the list of triggers to a card
    var triggers = ObservableArray<NSManagedObject>([])


    override init(coordinator: AppCoordinator) {
        super.init(coordinator: coordinator)
        databaseService = coordinator.databaseCoordinator!.databaseService
    }

    func setup() {
        appData?.currentHabit.bidirectionalBindTo(self.currentHabit)


        appData?.currentHabitTriggers.bindTo(self.triggers)
        self.triggers.observe { newTriggers in

            
        }

        appData?.currentHabitEntries.bindTo(self.entries)
        self.entries.observe { newEntries in
            let now = NSDate()
            let weekAgo = NSDate.previousDay(now, numberOfDays: 7)
            self.lastWeekEntries.diffInPlace(
                newEntries.sequence.filter { entry in
                    return entry.date.timeIntervalSinceDate(weekAgo) < 0
                }
            )
        }
    }

    // MARK: - User Events

    func handleCollectionTapped(index: NSIndexPath) {
        // expand the card that had been tapped (graph expands into larger graph, etc, Fitbit style)
    }

    func handleCollectionPressed(index: NSIndexPath) {
        // should we allow interactions of this kind?
    }
}