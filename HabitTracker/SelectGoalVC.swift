//
//  SelectGoalVC.swift
//  Tailor
//
//  Created by Logan Allen on 1/21/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift

class SelectGoalVC: FormViewController {

    struct rowNames {
        static let goalRow = "Select Goal"
        static let createRow = "Create New Goal"
        static let nextRow = "Next"
    }

    var realm: Realm? = nil
    var habitResults: Results<Habit>? = nil
    var goalResults: Results<Goal>? = nil

    var selectedGoalUUID: String? = nil
    var goalDicts: [String:Goal] { // Goal Name : Goal
        var dict = [String:Goal]()
        goalResults?.forEach { goal in
            dict.updateValue(goal, forKey:goal.name)
        }
        return dict
    }

    var pickerGoals: [String] { // Goal Name
        return goalResults?.map { goal in
            return goal.name
        } ?? [String]()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    func configureView() {
        // Update the user interface.
        do {
            realm = try Realm()
        } catch let err1 as NSError {
            print(err1)
        }
        goalResults = GoalHelper.queryGoals(false) // setting goal results calls configureView
        habitResults = HabitHelper.queryHabits()

        navigationOptions = .Disabled
        let goalPicker = PickerInlineRow<String>(rowNames.goalRow) {
            $0.title = $0.tag
            $0.options = self.pickerGoals
            $0.hidden = Condition.Function([rowNames.goalRow], {row in
                return self.pickerGoals.count == 0
            })
        }.onChange { [weak self] row in
            if row.value != nil {
                self?.selectedGoalUUID = self?.goalDicts[row.value!]?.uuid
            }
        }

        let createButton = ButtonRow(rowNames.createRow) {
            $0.title = $0.tag
        }.onCellSelection {_,_ in
            self.performSegueWithIdentifier(Constants.Segues.showAddGoal, sender: nil)
        }

        form +++ Section()
            <<< goalPicker
            <<< createButton

        let nextButton = ButtonRow(rowNames.nextRow) {
            $0.title = $0.tag
            $0.disabled = Condition.Function([rowNames.goalRow], {row in
                return self.selectedGoalUUID == nil
            })
        }.onCellSelection { _,row in
            if row.isDisabled {
                // show alert to say that this is disabled
            } else {
                self.performSegueWithIdentifier(Constants.Segues.showAddHabit, sender: nil)
            }
        }

        form +++= nextButton
    }

    func refreshRealm() {
        realm?.refresh()
        // refreshView()
    }

    func refreshView() {
        let goalRow: PickerInlineRow<String>? = form.rowByTag(rowNames.goalRow)
        goalRow?.collapseInlineRow()
        goalRow?.options = pickerGoals
        goalRow?.evaluateHidden()
        goalRow?.updateCell()
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.Segues.showAddGoal {
            let controller = segue.destinationViewController as! AddGoalViewController
            controller.maxGoalOrder = goalResults?.count ?? 0
        } else if segue.identifier == Constants.Segues.showAddHabit {
            let controller = segue.destinationViewController as! AddHabitViewController
            controller.maxHabitOrder = habitResults?.count ?? 0
            controller.goalUUID = self.selectedGoalUUID
        }
    }

}