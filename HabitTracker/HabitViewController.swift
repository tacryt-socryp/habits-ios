//
//  HabitViewController.swift
//  Tailor
//
//  Created by Logan Allen on 2/5/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit
import Eureka

class HabitViewController: FormViewController {

    struct rowNames {
        static let nameRow = "Habit Name"
        static let useNumberOfDaysRow = "Use Number of Days"
        static let numberOfDaysRow = "Number of Days"
        static let weekDaysRow = "Week Days"
        static let goalRow = "Goal"
        static let createRow = "Save Habit"
    }

    enum viewStates {
        case View
        case Edit
        case Create
    }

    var currentState: Set<viewStates> = [viewStates.View]

    var dataController: DataController!
    var habit: Habit? = nil {
        didSet {
            form.allRows.forEach {
                $0.updateCell()
                $0.evaluateDisabled()
                $0.evaluateHidden()
            }
        }
    }

    var maxHabitOrder: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    func configureView() {
        // Update the user interface.
        navigationOptions = .Disabled

        var isViewMode: Bool {
            return currentState.contains(.View)
        }
        var isEditMode: Bool {
            return currentState.contains(.Edit)
        }
        var isCreateMode: Bool {
            return currentState.contains(.Create)
        }

        if isViewMode {
            let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "toggleEditMode")
            self.navigationItem.rightBarButtonItem = editButton
        }

        form +++ Section()
            <<< NameRow(rowNames.nameRow) {
                if !isCreateMode {
                    if let h = habit {
                        $0.value = h.name
                    }
                }
                $0.updateCell()
                if isEditMode {
                    $0.title = $0.tag
                }
                $0.disabled = Condition.Function([rowNames.nameRow]) {_ in
                    return !isEditMode
                }
            }
            <<< SwitchRow(rowNames.useNumberOfDaysRow) {
                if isCreateMode {
                    $0.value = false
                } else {
                    if let h = habit {
                        $0.value = h.useNumDays == 1
                    }
                }
                if isEditMode {
                    $0.title = $0.tag
                }
                $0.hidden = Condition.Function([rowNames.useNumberOfDaysRow]) {_ in
                    return isViewMode
                }

            }
            <<< WeekDayRow(rowNames.weekDaysRow) {
                if isCreateMode {
                    $0.value = [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday]
                } else {
                    $0.value = self.convertDataToWeekDays()
                }
                if isEditMode {
                    $0.title = $0.tag
                } else {
                    $0.disabled = Condition.Function([rowNames.weekDaysRow]) {_ in
                        return !isEditMode
                    }
                }
            }
            <<< TextRow(rowNames.goalRow) {
                if !isCreateMode {
                    if let h = habit {
                        $0.value = h.goal
                    }
                }
                if isEditMode {
                    $0.title = $0.tag
                }
            }

        form +++= Section()
            <<< ButtonRow(rowNames.createRow) {
                $0.title = $0.tag
                $0.hidden = Condition.Function([rowNames.createRow]) {_ in 
                    return !isEditMode
                }
            }.onCellSelection {_,_ in
                self.writeHabit()
                if isCreateMode {
                    if let splitControllers = self.splitViewController?.viewControllers {
                        let navViewController = splitControllers[0] as! UINavigationController
                        for controller in navViewController.viewControllers {
                            if let masterViewController = controller as? MasterViewController {
                                navViewController.popToViewController(masterViewController, animated: true)
                            }
                        }
                    }
                } else {
                    self.currentState.removeAll()
                    self.currentState.insert(.View)
                }
            }
    }


    func convertDataToWeekDays() -> Set<WeekDay> {
        var weekDays = Set<WeekDay>()
        if let habit = habit {
            if habit.monday == 1 {
                weekDays.insert(.Monday)
            }
            if habit.tuesday == 1 {
                weekDays.insert(.Tuesday)
            }
            if habit.wednesday == 1 {
                weekDays.insert(.Wednesday)
            }
            if habit.thursday == 1 {
                weekDays.insert(.Thursday)
            }
            if habit.friday == 1 {
                weekDays.insert(.Friday)
            }
            if habit.saturday == 1 {
                weekDays.insert(.Saturday)
            }
            if habit.sunday == 1 {
                weekDays.insert(.Sunday)
            }
        }
        return weekDays
    }

    func writeHabit() {
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

        if currentState.contains(.Create) {
            dataController.insertHabit(name, numDays: numDays, weekDays: weekDays, goal: goal)
        } else {
            dataController.updateHabit(habit!.objectID, name: name, numDays: numDays, weekDays: weekDays, goal: goal)
            toggleEditMode()
        }
    }


    // MARK: - Enable Edit Mode

    func toggleEditMode() {
        if self.currentState.contains(.Edit) {
            self.currentState.remove(.Edit)
        } else {
            self.currentState.insert(.Edit)
            self.currentState.remove(.View)
            self.currentState.remove(.Create)
            self.navigationItem.rightBarButtonItem = nil
        }

        form.allRows.forEach {
            $0.updateCell()
            $0.evaluateDisabled()
            $0.evaluateHidden()
        }
    }

}