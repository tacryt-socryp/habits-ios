//
//  SevenDayCardView.swift
//  Tailor
//
//  Created by Logan Allen on 3/6/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit

class LastSevenDaysCardView: CardView {

    var weekDayViews: [CenteredImageTextView] = []
    var letters = ["S", "M", "T", "W", "T", "F", "S"]

    override func setup() {
        let stackView = UIStackView(frame: contentView.frame)

        if let cardData = cardData as? LastSevenDaysCardData, let entries = cardData.entryArray {

            // add CenteredImageTextViews to the stack with S, M, T, W, T, F, S as text
            var i = 0
            while i < 7 {
                let newView = CenteredImageTextView.instanceFromNib() as! CenteredImageTextView
                newView.textLabel.text = letters[i]

                newView.imageView.contentMode = .Center
                newView.imageView.image = UIImage(named: "uncheckedDay")


                let widthConstraint = NSLayoutConstraint(item: newView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: contentView.frame.size.width / 7)
                newView.addConstraint(widthConstraint)

                let heightConstraint = NSLayoutConstraint(item: newView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: contentView.frame.size.height)
                newView.addConstraint(heightConstraint)
                weekDayViews.append(newView)
                stackView.addArrangedSubview(newView)
                i += 1
            }

            var pastWeek = Set<WeekDay>()
            let sixDaysAgo = NSDate.previousDay(NSDate(), numberOfDays: 6)

            entries.filter({ (entry: Entry) -> Bool in
                return entry.date.timeIntervalSince1970 >= sixDaysAgo.timeIntervalSince1970
            }).forEach({ entry in

                // populate past week set with days that have entries
                var i = 0
                while i < 7 {
                    let day = WeekDay(rawValue: i)!
                    if (entry.sameDay(
                            NSDate.setDay(NSDate(), day: day)
                        )) {
                        print(entry)
                        print(NSDate.setDay(NSDate(), day: day))
                        print(day)
                        print(i)
                        pastWeek.insert(day)
                    }
                    i += 1
                }
            })

            pastWeek.forEach { val in
                var rawVal = val.rawValue + 1
                if (val.rawValue == 7) {
                    rawVal = 0
                }
                let dayView = stackView.arrangedSubviews[rawVal] as? CenteredImageTextView
                dayView?.imageView.image = UIImage(named: "checkedDay")
            }

        }

        contentView.addSubview(stackView)
    }
}