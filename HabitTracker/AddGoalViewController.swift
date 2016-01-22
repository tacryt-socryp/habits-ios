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
        static let createRow = "Create Goal"
    }

    var maxGoalOrder: Int = 0


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
                $0.title = $0.tag
            }

        form +++= Section()
            <<< ButtonRow(rowNames.createRow) {
                $0.title = $0.tag
            }.onCellSelection {_,_ in
                if let splitControllers = self.splitViewController?.viewControllers {
                    let navViewController = splitControllers[0] as! UINavigationController
                    for controller in navViewController.viewControllers {
                        if let selectGoal = controller as? SelectGoalVC {
                            self.addGoal(selectGoal)
                            navViewController.popToViewController(selectGoal, animated: true)
                        }
                    }
                }
            }
    }

    func addGoal(vc: SelectGoalVC? = nil) {
        let values = form.values()
        let name = values[rowNames.nameRow] as! String

        GoalHelper.createGoal(name, goalOrder: maxGoalOrder, habitUUIDs: [String](), complete: { () -> () in
            dispatch_async(dispatch_get_main_queue()) {
                vc?.refreshRealm()
            }
        })
    }
    
}