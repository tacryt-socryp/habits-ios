//
//  AddHabitViewController.swift
//  HabitTracker
//
//  Created by Logan Allen on 1/18/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit
import Eureka

class AddHabitViewController: FormViewController {

    struct rowNames {
        static let nameRow = "Habit Name"
        static let useNumberOfDaysRow = "Use Number of Days"
        static let numberOfDaysRow = "Number of Days"
        static let weekDaysRow = "Week Days"
        static let goalRow = "Goal"
        static let createRow = "Add Habit"
    }

    var dataController: DataController!
    var habitUUID: String? = nil // if habitUUID is set, edit mode, not create.
    var maxHabitOrder: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    func configureView() {
        // Update the user interface.
        navigationOptions = .Disabled
        form +++ Section()
            <<< NameRow(rowNames.nameRow) {
                $0.title =  $0.tag
            }
            <<< SwitchRow(rowNames.useNumberOfDaysRow) {
                $0.title = $0.tag
                $0.value = false
            }
            <<< WeekDayRow(rowNames.weekDaysRow) {
                $0.title = $0.tag
                $0.value = [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday]
            }
            <<< TextRow(rowNames.goalRow) {
                $0.title =  $0.tag
            }

        form +++= Section()
            <<< ButtonRow(rowNames.createRow) {
                $0.title = $0.tag
            }.onCellSelection {_,_ in
                if let splitControllers = self.splitViewController?.viewControllers {
                    let navViewController = splitControllers[0] as! UINavigationController
                    for controller in navViewController.viewControllers {
                        if let masterViewController = controller as? MasterViewController {
                            self.addHabit(masterViewController)
                            navViewController.popToViewController(masterViewController, animated: true)
                        }
                    }
                }
            }
    }

    func addHabit(mV: MasterViewController? = nil) {
        let values = form.values()
        let name = values[rowNames.nameRow] as! String
        let goal = values[rowNames.goalRow] as? String
        let useNumDays = values[rowNames.useNumberOfDaysRow] as! Bool

        var numDays: Int? = nil
        var weekDays: Set<WeekDay>? = nil

        if useNumDays {
            numDays = values[rowNames.numberOfDaysRow] as? Int
        } else {
            weekDays = values[rowNames.weekDaysRow] as? Set<WeekDay>
        }

        dataController.insertHabit(name, numDays: numDays, weekDays: weekDays, goal: goal)
    }

}
