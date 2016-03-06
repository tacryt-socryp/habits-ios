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
    
    var allCards = ObservableArray<CardData>([])

    override init(coordinator: AppCoordinator) {
        super.init(coordinator: coordinator)
        databaseService = coordinator.databaseCoordinator!.databaseService
    }

    func setup() {

        appData?.allHabits.observe({ event in
            self.allCards.diffInPlace(event.sequence.map({ (habit: Habit) -> CardData in
                let cardData = HabitGridCardData()
                cardData.habit = habit
                return cardData
            }))
        })

    }

    // MARK: - User Events
    func addTapped() {
        databaseService.insertHabit(
            "Running",
            weekDays: Set<WeekDay>(arrayLiteral: WeekDay.Monday, WeekDay.Tuesday)
        )
    }

    func handleCollectionTapped(index: NSIndexPath) {
        // set current habit in app data store
        // open individual habit view
        if let cardData = self.allCards[index.row] as? HabitGridCardData, let habit = cardData.habit {
            appData?.currentHabit.next(habit)
            let viewHabit = routeCoordinator.routeEnumToURL(routesEnum.viewHabit)
            routeCoordinator.navigateToRoute(viewHabit, options: nil)
        }
    }

    func handleCollectionPressed(index: NSIndexPath) {

        if let cardData = self.allCards[index.row] as? HabitGridCardData, let habit = cardData.habit {
            databaseService.insertEntry(habit)
            self.allCards.performBatchUpdates{ array in
                if let card = array.removeAtIndex(index.row) as? HabitGridCardData {
                    card.habit?.isTodayComplete = true
                    array.insert(card, atIndex: index.row)
                }
            }
        }

    }
}