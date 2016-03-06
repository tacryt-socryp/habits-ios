//
//  SevenDayCardView.swift
//  Tailor
//
//  Created by Logan Allen on 3/6/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit

class LastSevenDaysCardView: CardView {

    @IBOutlet var entriesLabel: UILabel!

    override func setup() {
        if let cardData = cardData as? LastSevenDaysCardData, let entries = cardData.entryArray {
            var text = ""
            entries.forEach { entry in
                text += String(entry.day) + " "
            }
            entriesLabel.text = text
        }
    }
}