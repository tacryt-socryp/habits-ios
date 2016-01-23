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
        static let goalRow = "Goals"
        static let orderRow = "Select Order"
        static let createRow = "Add Habit"
    }

    var goalUUID: String? = nil

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
            <<< IntRow(rowNames.orderRow) { // TODO: do this automatically, allow changing afterwards
                $0.title = $0.tag
            }

        form +++= Section()
            <<< ButtonRow(rowNames.createRow) {
                $0.title = $0.tag
                // $0.presentationMode = .SegueName(segueName: "RowsExampleViewControllerSegue", completionCallback: nil)
            }.onCellSelection {_,_ in
                if let splitControllers = self.splitViewController?.viewControllers {
                    let navViewController = splitControllers[0] as! UINavigationController
                    for controller in navViewController.viewControllers {
                        if let masterViewController = controller as? MasterViewController {
                            self.addHabit(masterViewController)
                            masterViewController.refreshRealm()
                            navViewController.popToViewController(masterViewController, animated: true)
                        }
                    }
                }
            }
    }

    func addHabit(mV: MasterViewController? = nil) {
        let values = form.values()
        let name = values[rowNames.nameRow] as! String
        let habitOrder = values[rowNames.orderRow] as! Int
        print(goalUUID)

        HabitHelper.createHabit(name, habitOrder: habitOrder, goalUUID: goalUUID, complete: { () -> () in
            dispatch_async(dispatch_get_main_queue()) {
                mV?.refreshRealm()
            }
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.Segues.showHabitMaster {
            // let controller = (segue.destinationViewController as! UINavigationController).topViewController as! MasterViewController
            // controller.refreshRealm()
        }
    }

}
