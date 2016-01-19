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

    func configureView() {
        // Update the user interface.
        form +++ Section()
            <<< NameRow("Habit Name") {
                $0.title =  $0.tag
            }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

}
