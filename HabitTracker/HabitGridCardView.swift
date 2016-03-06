//
//  HabitGridCardView.swift
//  Tailor
//
//  Created by Logan Allen on 2/25/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit

class HabitGridCardView: CardView {

    @IBOutlet var habitName: UILabel!

    override func setup() {
        if let cardData = cardData as? HabitGridCardData, let habit = cardData.habit {
            habitName.text = habit.name
            self.backgroundColor = habit.isTodayComplete ? UIColor.greenColor() : UIColor.whiteColor()
        }

    }
}