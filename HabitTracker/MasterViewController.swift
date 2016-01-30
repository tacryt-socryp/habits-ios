//
//  MasterViewController.swift
//  HabitTracker
//
//  Created by Logan Allen on 1/17/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    // MARK: - Attributes

    var fetchedResults: NSFetchedResultsController!

    var detailViewController: DetailViewController? = nil


    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        let request = NSFetchRequest(entityName: "Habit")
        let orderSort = NSSortDescriptor(key: "habit.order", ascending: true)
        request.sortDescriptors = [orderSort]

        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).dataController.managedObjectContext
        self.fetchedResults = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: moc,
            sectionNameKeyPath: nil,
            cacheName: "rootCache"
        )
        self.fetchedResults.delegate = self

        do {
            try self.fetchedResults.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResults: \(error)")
        }
        self.configureView()
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    func configureView() {
        // HabitHelper.deleteAllObjects()
        // HabitHelper.createHabit("Running", habitOrder: 0)
        // HabitHelper.createHabit("Weight Lifting", habitOrder: 1)
        // habits = HabitHelper.queryHabits()

        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addNewHabit")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }


    // MARK: - Segues

    func addNewHabit() {
        self.performSegueWithIdentifier(Constants.Segues.showAddHabit, sender: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.Segues.showHabitDetail {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if let habit = self.fetchedResults.objectAtIndexPath(indexPath) as? Habit {
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
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let habit = self.fetchedResults.objectAtIndexPath(indexPath) as! Habit
        // Populate cell from the NSManagedObject instance
        cell.textLabel?.text = habit.name
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.TableCells.Cell, forIndexPath: indexPath) 
        // Set up the cell
        self.configureCell(cell, indexPath: indexPath)
        return cell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = self.fetchedResults.sections
        return sections?[section].numberOfObjects ?? 0
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if let habit = self.fetchedResults.objectAtIndexPath(indexPath) as? Habit {
                /*HabitHelper.deleteHabit(habit.uuid) {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.refreshRealm()
                    }
                }*/
            } else {
                // do an error message
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


    // MARK: - Fetched Results Controller Delegate
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            self.configureCell(self.tableView.cellForRowAtIndexPath(indexPath!)!, indexPath: indexPath!)
        case .Move:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            self.tableView.insertRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }


}

