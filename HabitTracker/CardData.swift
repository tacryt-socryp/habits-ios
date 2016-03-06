//
//  CardData.swift
//  Tailor
//
//  Created by Logan Allen on 3/6/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit

class CardData: NSObject {
    var cardType = ""
}

class HabitGridCardData: CardData {
    var habit: Habit? = nil
    
    override init() {
        super.init()
        self.cardType = Constants.CardEnum.habitGridCard.rawValue
    }

    func itemSize() -> CGSize {
        return CGSizeMake(165,165)
    }
}

class LastSevenDaysCardData: CardData {
    var entryArray: [Entry]? = nil

    override init() {
        super.init()
        self.cardType = Constants.CardEnum.lastSevenDaysCard.rawValue
    }

    func itemSize() -> CGSize {
        return CGSizeMake(345,165)
    }
}