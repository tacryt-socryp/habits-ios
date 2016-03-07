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
        let exampleCard = HabitGridCardData()
        self.currentHabit.observe { habit in
            exampleCard.habit = habit
        }
        allCards.insert(exampleCard, atIndex: 0)

        appData?.currentHabitTriggers.bindTo(self.triggers)
        self.triggers.observe { newTriggers in


        }
        // print(self.currentHabit.value)
        print(self.currentHabit.value!.entries)

        appData?.currentHabitEntries.bindTo(self.entries)
        self.entries.observe { newEntries in
            let now = NSDate()
            let weekAgo = NSDate.previousDay(now, numberOfDays: 7)
            self.lastWeekEntries.diffInPlace(
                newEntries.sequence.filter { entry in
                    return entry.date.timeIntervalSinceDate(weekAgo) > 0
                }
            )
        }

        let example2Card = LastSevenDaysCardData()
        self.lastWeekEntries.observe { entries in
            example2Card.entryArray = entries.sequence
        }
        allCards.insert(example2Card, atIndex: 1)
    }

    // MARK: - User Events

    func handleCollectionTapped(index: NSIndexPath) {

    }

    func handleCollectionPressed(index: NSIndexPath) {
        
    }

    func handleItemSize(index: NSIndexPath) -> CGSize? {
        let cardData = self.allCards.array[index.row]
        if let cardType = Constants.CardEnum(rawValue: cardData.cardType) {
            switch cardType {
            case .habitGridCard:
                return (cardData as! HabitGridCardData).itemSize()
            case .lastSevenDaysCard:
                return (cardData as! LastSevenDaysCardData).itemSize()
            }
        }
        return nil
    }
}