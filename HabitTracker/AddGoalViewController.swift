//
//  AddGoalViewController.swift
//  Tailor
//
//  Created by Logan Allen on 1/20/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//


import UIKit
import Eureka

class AddGoalViewController: FormViewController {

    struct rowNames {
        static let nameRow = "Goal Name"
        static let orderRow = "Select Order"
        static let createRow = "Add Goal"
    }


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
        form +++= Section()
            <<< ButtonRow(rowNames.createRow) {
                $0.title = $0.tag
                // $0.presentationMode = .SegueName(segueName: "RowsExampleViewControllerSegue", completionCallback: nil)
                }.onCellSelection {_,_ in
                    if let splitControllers = self.splitViewController?.viewControllers {
                        let navViewController = splitControllers[0] as! UINavigationController
                        for controller in navViewController.viewControllers {
                            if let masterViewController = controller as? MasterViewController {
                                self.addHabit()
                                masterViewController.refreshRealm()
                                navViewController.popToViewController(masterViewController, animated: true)
                            }
                        }

                    }
        }
    }

    func addHabit() {
        let values = form.values()
        let name = values[rowNames.nameRow] as! String
        //let habitOrder = values[rowNames.orderRow] as! Int

        HabitHelper.createHabit(name, habitOrder: 0)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMaster" {
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! MasterViewController
            controller.refreshRealm()
        }
    }
    
}