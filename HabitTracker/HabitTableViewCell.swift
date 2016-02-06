//
//  HabitTableViewCell.swift
//  Tailor
//
//  Created by Logan Allen on 2/6/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit

class HabitTableViewCell: UITableViewCell {

    var originalCenter = CGPoint()
    var addEntryOnDragRelease = false
    var delegate: HabitTableViewCellDelegate? = nil
    var habitItem: Habit? = nil

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        let recognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
//        recognizer.delegate = self
//        addGestureRecognizer(recognizer)
    }


    // MARK: - horizontal pan gesture methods

    /*func handlePan(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .Began {
            // when the gesture begins, record the current center location
            originalCenter = center
        }

        if recognizer.state == .Changed {
            let translation = recognizer.translationInView(self)
            center = CGPointMake(originalCenter.x + translation.x, originalCenter.y)
            // has the user dragged the item far enough to initiate a complete?
            addEntryOnDragRelease = frame.origin.x > frame.size.width / 2.0
        }

        if recognizer.state == .Ended {
            // the frame this cell had before user dragged it
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                width: bounds.size.width, height: bounds.size.height)
            if addEntryOnDragRelease {
                if delegate != nil && habitItem != nil {
                    // notify the delegate that an entry should be added for today
                    delegate!.addEntryForToday(habitItem!)
                }
            } else {
                // if the item is not being completed, snap back to the original location
                UIView.animateWithDuration(0.2, animations: {self.frame = originalFrame})
            }
        }
    }

    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }*/

}