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
        static let weekDaysRow = "Week Days"
        static let createRow = "Save Habit"
    }

    enum viewStates {
        case Create
    }

    // SET THESE
    var currentState: Set<viewStates>!
    var dataController: DatabaseService!
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

        var isCreateMode: Bool {
            return currentState.contains(.Create)
        }

        form +++ Section()
            <<< NameRow(rowNames.nameRow) {
                if !isCreateMode {
                    if let h = habit {
                        $0.value = h.name
                    }
                }
                $0.updateCell()
                $0.title = $0.tag
            }
            <<< WeekDayRow(rowNames.weekDaysRow) {
                if isCreateMode {
                    $0.value = [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday]
                } else {
                    $0.value = self.convertDataToWeekDays()
                }

                $0.title = $0.tag
            }

        form +++= Section()
            <<< ButtonRow(rowNames.createRow) {
                $0.title = $0.tag
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
                    self.navigationController?.popViewControllerAnimated(true)
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

        let weekDays: Set<WeekDay>? = values[rowNames.weekDaysRow] as? Set<WeekDay>

        if currentState.contains(.Create) {
            dataController.insertHabit(name, weekDays: weekDays)
        } else {
            dataController.updateHabit(habit!.objectID, name: name, weekDays: weekDays)
            testNotification(habit!)
        }
    }


    // TODO: REMOVE THIS AFTER TESTING
    func testNotification(habit: Habit) {
        let dict = NSMutableDictionary()
        let weekDays: NSSet = [
            WeekDay.Saturday.rawValue
        ]

        let repeatInterval: NSCalendarUnit = [.WeekOfYear]
        // let repeatInterval: NSCalendarUnit = [.Day]
        let reminderText = "I'm showing you this notification every week!"

        dict.setValue(weekDays, forKey: TimeTrigger.timeDictKeys.weekDays)
        dict.setValue(NSDate().dateByAddingTimeInterval(60), forKey: TimeTrigger.timeDictKeys.dateInfo)
        dict.setValue(repeatInterval.rawValue, forKey: TimeTrigger.timeDictKeys.repeatInterval)
        dict.setValue(reminderText, forKey: TimeTrigger.dictKeys.reminderText)

        dataController.insertTrigger(habit, data: dict, type: TriggerTypes.Time)
    }

}