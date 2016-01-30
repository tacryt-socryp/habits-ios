//
//  CustomEurekaCells.swift
//  Tailor
//
//  Created by Logan Allen on 1/30/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import Foundation
import Eureka

//MARK: WeeklyDayCell

public enum WeekDay {
    case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
}

public class WeekDayCell : Cell<Set<WeekDay>>, CellType {

    @IBOutlet var sundayButton: UIButton!
    @IBOutlet var mondayButton: UIButton!
    @IBOutlet var tuesdayButton: UIButton!
    @IBOutlet var wednesdayButton: UIButton!
    @IBOutlet var thursdayButton: UIButton!
    @IBOutlet var fridayButton: UIButton!
    @IBOutlet var saturdayButton: UIButton!

    public override func setup() {
        height = { 60 }
        row.title = nil
        super.setup()
        selectionStyle = .None
        for subview in contentView.subviews {
            if let button = subview as? UIButton {
                button.setImage(UIImage(named: "checkedDay"), forState: UIControlState.Selected)
                button.setImage(UIImage(named: "uncheckedDay"), forState: UIControlState.Normal)
                button.adjustsImageWhenHighlighted = false
                imageTopTitleBottom(button)
            }
        }
    }

    public override func update() {
        row.title = nil
        super.update()
        let value = row.value
        mondayButton.selected = value?.contains(.Monday) ?? false
        tuesdayButton.selected = value?.contains(.Tuesday) ?? false
        wednesdayButton.selected = value?.contains(.Wednesday) ?? false
        thursdayButton.selected = value?.contains(.Thursday) ?? false
        fridayButton.selected = value?.contains(.Friday) ?? false
        saturdayButton.selected = value?.contains(.Saturday) ?? false
        sundayButton.selected = value?.contains(.Sunday) ?? false

        mondayButton.alpha = row.isDisabled ? 0.6 : 1.0
        tuesdayButton.alpha = mondayButton.alpha
        wednesdayButton.alpha = mondayButton.alpha
        thursdayButton.alpha = mondayButton.alpha
        fridayButton.alpha = mondayButton.alpha
        saturdayButton.alpha = mondayButton.alpha
        sundayButton.alpha = mondayButton.alpha
    }

    @IBAction func dayTapped(sender: UIButton) {
        dayTapped(sender, day: getDayFromButton(sender))
    }

    private func getDayFromButton(button: UIButton) -> WeekDay{
        switch button{
        case sundayButton:
            return .Sunday
        case mondayButton:
            return .Monday
        case tuesdayButton:
            return .Tuesday
        case wednesdayButton:
            return .Wednesday
        case thursdayButton:
            return .Thursday
        case fridayButton:
            return .Friday
        default:
            return .Saturday
        }
    }

    private func dayTapped(button: UIButton, day: WeekDay){
        button.selected = !button.selected
        if button.selected{
            row.value?.insert(day)
        }
        else{
            row.value?.remove(day)
        }
    }

    private func imageTopTitleBottom(button : UIButton){

        guard let imageSize = button.imageView?.image?.size else { return }
        let spacing : CGFloat = 3.0
        button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing), 0.0)
        guard let titleLabel = button.titleLabel, let title = titleLabel.text else { return }
        let titleSize = title.sizeWithAttributes([NSFontAttributeName: titleLabel.font])
        button.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0, 0, -titleSize.width)
    }
}

//MARK: WeekDayRow

public final class WeekDayRow: Row<Set<WeekDay>, WeekDayCell>, RowType {

    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellProvider = CellProvider<WeekDayCell>(nibName: "WeekDaysCell")
    }
}