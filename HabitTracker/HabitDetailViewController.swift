//
//  HabitDetailViewController.swift
//  Tailor
//
//  Created by Logan Allen on 2/6/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit

class HabitDetailViewController: UIViewController {

    var dataController: DataController!
    var habit: Habit? = nil {
        didSet {
            self.configureView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    func configureView() {
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editHabit")
        self.navigationItem.rightBarButtonItem = editButton
    }

    func editHabit() {
        self.performSegueWithIdentifier(Constants.Segues.showEditHabit, sender: nil)

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.Segues.showEditHabit {
            let controller = segue.destinationViewController as! HabitViewController
            controller.dataController = self.dataController
            controller.currentState = [.Edit]
            controller.habit = habit
        }
    }

}
