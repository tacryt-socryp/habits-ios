//
//  Constants.swift
//  Tailor
//
//  Created by Logan Allen on 1/20/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit

struct Constants {

    static let iCloudID = "iCloud.com.loganallc.TailorHabits"

    struct Colors {
        static let darkPrimary = Constants.UIColorConverter(0x0097A7)
        static let normalPrimary = Constants.UIColorConverter(0x00BCD4)
        static let accent = Constants.UIColorConverter(0x7C4DFF)
    }

    struct ViewControllers {
        static let addHabit = "addHabitVC"
    }

    struct Segues {
        static let showHabitDetail = "showHabitDetail"
        static let showHabitMaster = "showHabitMaster"
        static let showAddHabit = "showAddHabit"
    }

    struct Notifications {
        static let fetchTableData = "tailorFetchTableData"
    }

    struct TableCells {
        static let Cell = "Cell"
    }

    static func UIColorConverter(hex: Int, alpha: CGFloat = 1.0) -> UIColor {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}