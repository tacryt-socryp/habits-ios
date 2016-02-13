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
    var habitItem: Habit? = nil {
        didSet {
            self.configureView()
        }
    }

    let uncheckedColor = UIColor.whiteColor()
    let checkedColor = Constants.Colors.accent

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureView() {
        if habitItem != nil {
            if !habitItem!.isTodayComplete {
                let swipePan: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handleSwipePan:")
                swipePan.delegate = self
                addGestureRecognizer(swipePan)

                // for showing a color underneath the row
                let textView = UITextView(frame: CGRect(x: -1 * self.frame.width, y: 0, width: self.frame.width, height: self.frame.height))
                textView.editable = false
                textView.backgroundColor = checkedColor
                textView.textAlignment = .Right
                textView.textColor = UIColor.whiteColor()
                textView.text = "✔︎"
                textView.font = UIFont.systemFontOfSize(18)
                textView.textContainerInset = UIEdgeInsets(
                    top: (self.frame.height - textView.font!.lineHeight) / 2.0,
                    left: 0.0,
                    bottom: 0.0,
                    right: 15.0
                )


                self.addSubview(textView)

                self.contentView.backgroundColor = UIColor.whiteColor()
                self.bringSubviewToFront(self.contentView)
            } else {
                self.contentView.backgroundColor = checkedColor
                self.textLabel?.textColor = UIColor.whiteColor()
            }
        }
    }


    // MARK: - horizontal pan gesture methods

    func handleSwipePan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .Began:
            originalCenter = center
        case .Changed:
            let translation = recognizer.translationInView(self)
            center = CGPointMake(originalCenter.x + translation.x, center.y)

            // has the user dragged the item halfway?
            addEntryOnDragRelease = frame.origin.x > frame.size.width / 2.0
        case .Ended:
            // the frame this cell had before user dragged it
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                width: bounds.size.width, height: bounds.size.height)

            if addEntryOnDragRelease && delegate != nil && habitItem != nil {
                // notify the delegate that an entry should be added for today
                delegate!.addEntryForToday(habitItem!)
                self.textLabel?.textColor = UIColor.whiteColor()
                self.contentView.backgroundColor = Constants.Colors.accent
            }

            // snap back to the original location
            UIView.animateWithDuration(0.2, animations: {self.frame = originalFrame})
        default:
            break
        }
    }
}