//
//  CreateHabitViewController.swift
//  Tailor
//
//  Created by Logan Allen on 4/1/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit
import Bond
import Eureka

struct createRowNames {
    static let nameRow = "Habit Name"
    static let weekDaysRow = "Week Days"
    static let saveRow = "Save Habit"
}

class CreateHabitViewController: FormViewController, AppViewController {

    var viewModel : CreateHabitModel? = nil

    func setup(viewModel: ViewModel) {
        self.viewModel = viewModel as? CreateHabitModel
        if viewModel is CreateHabitModel {
            // Update the user interface.
            navigationOptions = .Disabled

            form +++ Section()
                <<< NameRow(createRowNames.nameRow) {
                    $0.title = $0.tag
                }
                <<< WeekDayRow(createRowNames.weekDaysRow) {
                    $0.value = [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday]
                    $0.title = $0.tag
            }

            form +++= Section()
                <<< ButtonRow(createRowNames.saveRow) {
                    $0.title = $0.tag
                }.onCellSelection { _,_ in
                    self.viewModel?.writeHabit(self.form)
                    self.navigationController?.popViewControllerAnimated(true)
                }
        }
        self.viewModel?.setup()
    }

    // use bond
    func bindModel() {
    }

}