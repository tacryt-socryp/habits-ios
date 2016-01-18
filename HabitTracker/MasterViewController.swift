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

    var priorities: Results<Priority>? = nil
    var habits: Results<Habit>? = nil
    var realm: Realm? = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            realm = try Realm()
        } catch let err1 as NSError {
            print(err1)
        }
        print(Realm.Configuration.defaultConfiguration.path!)
        //HabitHelper.deleteAllObjects()
        //HabitHelper.createHabit("Running", active: true, habitOrder: 0)
        //HabitHelper.createHabit("Weight Lifting", active: true, habitOrder: 1)
        habits = HabitHelper.queryHabits(true)

        //let healthHabits = habits?.map({ $0.uuid }) ?? [String]()
        //PriorityHelper.createPriority("Health", priorityOrder: 0, habitUUIDs: healthHabits)
        //PriorityHelper.updatePriority("914AB4A7-1A65-4F7B-85AF-1A319066528B", habitUUIDs: healthHabits)
        priorities = PriorityHelper.queryPriorities(true)

        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refreshRealm() {
        realm?.refresh()
        tableView.reloadData()
    }

    func insertNewObject(sender: AnyObject) {
        HabitHelper.createHabit("Running", active: true, habitOrder: 0, priorityUUID: "914AB4A7-1A65-4F7B-85AF-1A319066528B")
        refreshRealm()
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if let habit = habits?[indexPath.row] {
                    let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                    controller.detailItem = habit
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
        return priorities?.count ?? 0
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return priorities?[section].name
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if numberOfSectionsInTableView(tableView) == 0 {
            return 0
        }
        return habits?.count ?? 0
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        if let habit = habits?[indexPath.row] {
            cell.textLabel?.text = habit.name
        }

        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if let habit = habits?[indexPath.row] {
                habits = habits?.filter("uuid != '\(habit.uuid)'")
                HabitHelper.deleteHabit(habit.uuid)
                refreshRealm()
            } else {
                // do an error message
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

