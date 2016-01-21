//
//  SelectGoalVC.swift
//  Tailor
//
//  Created by Logan Allen on 1/21/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit
import Eureka

class SelectGoalVC: FormViewController {

    struct rowNames {
        static let goalRow = "Select Goal"
        static let createRow = "Add Goal"
        static let nextRow = "Next"
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    func getValues() -> NSDictionary {
        // let values = form.values()
        // return values
        var values = form.values()
        var retValues = [String:AnyObject]()
        if let goal = values[rowNames.goalRow] {
            print(goal)
            retValues.updateValue(goal as! String, forKey: rowNames.goalRow)
        }
        return retValues as NSDictionary
    }

    func configureView() {
        // Update the user interface.
        navigationOptions = .Disabled
        form +++ Section()
            <<< PickerInlineRow<String>(rowNames.goalRow) {
                $0.title = $0.tag
                $0.options = []
                for i in 1...10{
                    $0.options.append("option \(i)")
                }
            }

        form +++= Section()
            <<< ButtonRow(rowNames.createRow) {
                $0.title = $0.tag
                // $0.presentationMode = .SegueName(segueName: "RowsExampleViewControllerSegue", completionCallback: nil)
            }.onCellSelection {_,_ in
                self.performSegueWithIdentifier(Constants.Segues.showAddGoal, sender: nil)
            }

        form +++= Section()
            <<< ButtonRow(rowNames.nextRow) {
                $0.title = $0.tag
            }.onCellSelection {_,_ in
                self.performSegueWithIdentifier(Constants.Segues.showAddHabit, sender: self.getValues())
            }
    }

}