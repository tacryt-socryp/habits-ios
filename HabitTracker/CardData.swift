//
//  CardData.swift
//  Tailor
//
//  Created by Logan Allen on 3/6/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import Foundation

class CardData: NSObject {
    var cardType: Constants.CardEnum? = nil
}

class HabitGridCardData: CardData {
    var habit: Habit? = nil
}

class LastSevenDaysCardData: CardData {
    var entryArray: [Entry]

    init(entries: [Entry]) {
        self.entryArray = entries
        super.init()
        self.cardType = Constants.CardEnum.lastSevenDaysCard
    }
}