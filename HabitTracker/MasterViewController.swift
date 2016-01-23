//
//  MasterViewController.swift
//  HabitTracker
//
//  Created by Logan Allen on 1/17/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit
import RealmSwift

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil

    var goals: Results<Goal>? = nil
    var realm: Realm? = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configureView() {
        do {
            realm = try Realm()
        } catch let err1 as NSError {
            print(err1)
        }
        print(Realm.Configuration.defaultConfiguration.path!)
        // HabitHelper.deleteAllObjects()
        // HabitHelper.createHabit("Running", habitOrder: 0)
        // HabitHelper.createHabit("Weight Lifting", habitOrder: 1)
        // habits = HabitHelper.queryHabits()

        // let healthHabits = habits?.map({ $0.uuid }) ?? [String]()
        // GoalHelper.createGoal("Health", goalOrder: 0, habitUUIDs: healthHabits)
        // GoalHelper.updateGoal("914AB4A7-1A65-4F7B-85AF-1A319066528B", habitUUIDs: healthHabits)
        goals = GoalHelper.queryGoals(true)

        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addNewHabit")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    func refreshRealm() {
        realm?.refresh()
        tableView.reloadData()
    }

    func addNewHabit() {
        self.performSegueWithIdentifier(Constants.Segues.showSelectGoal, sender: nil)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.Segues.showHabitDetail {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if let habit = goals?[indexPath.section].habits[indexPath.row] {
                    let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                    controller.habitItem = habit
                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                    controller.navigationItem.leftItemsSupplementBackButton = true
                } else {
                    // do an error message
                }
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return goals?.count ?? 0
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return goals?[section].name
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if numberOfSectionsInTableView(tableView) == 0 {
            return 0
        }
        return goals?[section].habits.count ?? 0
        //return habits?.count ?? 0
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.TableCells.Cell)!
        if let habit = goals?[indexPath.section].habits[indexPath.row] {
            cell.textLabel?.text = habit.name
        }

        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if let habit = goals?[indexPath.section].habits[indexPath.row] {
                HabitHelper.deleteHabit(habit.uuid) {
                    dispatch_async(dispatch_get_main_queue()) {
                        print(self)
                        self.refreshRealm()
                    }
                }
            } else {
                // do an error message
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

