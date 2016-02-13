//
//  MasterViewController.swift
//  HabitTracker
//
//  Created by Logan Allen on 1/17/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit
import CoreData

protocol HabitTableViewCellDelegate {
    // indicates that the given item has been deleted
    func addEntryForToday(habitItem: Habit)
}

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate, HabitTableViewCellDelegate {

    // MARK: - Attributes

    var dataController: DataController!
    var fetchedResults: NSFetchedResultsController!

    var detailViewController: HabitDetailViewController? = nil


    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        let request = NSFetchRequest(entityName: "Habit")
        let orderSort = NSSortDescriptor(key: "order", ascending: true)
        request.sortDescriptors = [orderSort]

        dataController = (UIApplication.sharedApplication().delegate as! AppDelegate).dataController
        let moc = dataController.managedObjectContext
        self.fetchedResults = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: moc,
            sectionNameKeyPath: nil,
            cacheName: "rootCache"
        )
        self.fetchedResults.delegate = self

        self.fetchTableData()
        self.registerTableViewNotifications()
        self.configureView()
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    func configureView() {
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "createNewHabit")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? HabitDetailViewController
        }
    }


    func registerTableViewNotifications() {
        let nc : NSNotificationCenter = NSNotificationCenter.defaultCenter();

        nc.addObserver(self, selector: "fetchTableData", name: Constants.Notifications.fetchTableData, object: nil)
    }

    func fetchTableData() {
        do {
            print("fetching")
            try self.fetchedResults.performFetch()
            self.tableView.reloadData()
        } catch {
            fatalError("Failed to initialize FetchedResults: \(error)")
        }
    }


    // MARK: - Segues

    func createNewHabit() {
        self.performSegueWithIdentifier(Constants.Segues.showCreateHabit, sender: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.Segues.showHabitDetail {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if let habit = self.fetchedResults.objectAtIndexPath(indexPath) as? Habit {
                    print(habit.name)
                    let controller = (segue.destinationViewController as! UINavigationController).topViewController as! HabitDetailViewController
                    controller.dataController = self.dataController
                    controller.habit = habit
                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                    controller.navigationItem.leftItemsSupplementBackButton = true
                } else {
                    // do an error message
                }
            }
        } else if segue.identifier == Constants.Segues.showCreateHabit {
            let controller = segue.destinationViewController as! HabitViewController
            controller.dataController = self.dataController
            controller.currentState = [.Create]
        }
    }


    // MARK: - Table View
    func configureCell(cell: HabitTableViewCell, indexPath: NSIndexPath) {
        let habit = self.fetchedResults.objectAtIndexPath(indexPath) as! Habit

        cell.delegate = self
        cell.habitItem = habit
        // Populate cell from the NSManagedObject instance
        cell.textLabel?.text = habit.name
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.TableCells.Cell, forIndexPath: indexPath) as! HabitTableViewCell

        // Set up the cell
        self.configureCell(cell, indexPath: indexPath)
        return cell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = self.fetchedResults.sections
        return sections?[section].numberOfObjects ?? 0
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if let habit = self.fetchedResults.objectAtIndexPath(indexPath) as? Habit {
                dataController.deleteHabit(habit)
            } else {
                // do an error message
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        // disable swipe to delete
        if (self.tableView.editing) {
            return UITableViewCellEditingStyle.Delete
        }
        return UITableViewCellEditingStyle.None
    }


    // MARK: - Fetched Results Controller Delegate

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            print("insert")
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            print("delete")
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            print("update")
            self.configureCell(self.tableView.cellForRowAtIndexPath(indexPath!) as! HabitTableViewCell, indexPath: indexPath!)
        case .Move:
            print("move")
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            self.tableView.insertRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }

    // MARK: - Habit Table View Delegate

    func addEntryForToday(habitItem: Habit) {
        // TODO: add an entry for today
        print("added entry for today!")
        dataController.insertEntry(habitItem)
    }

}

