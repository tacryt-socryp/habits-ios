//
//  DetailViewController.swift
//  HabitTracker
//
//  Created by Logan Allen on 1/17/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: - Attributes

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    var dataController: DataController!
    var habitItem: Habit? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }


    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }


    func configureView() {
        // Update the user interface for the detail item.
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editHabit")
        self.navigationItem.rightBarButtonItem = editButton

        if let habit = habitItem {
            if let label = detailDescriptionLabel {
                label.text = habit.name
            }
        }
    }


    // MARK: - Segues

    func editHabit() {
        self.performSegueWithIdentifier(Constants.Segues.showEditHabit, sender: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.Segues.showEditHabit {
            let controller = segue.destinationViewController as! EditHabitViewController
            controller.habit = self.habitItem
            controller.dataController = self.dataController
        }
    }

}
