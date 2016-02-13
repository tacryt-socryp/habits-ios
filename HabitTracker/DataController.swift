//
//  DataController.swift
//  Tailor
//
//  Created by Logan Allen on 1/29/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit
import CoreData

class DataController: NSObject {

    var managedObjectContext: NSManagedObjectContext

    override init() {
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = NSBundle.mainBundle().URLForResource("TailorModel", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }

        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }

        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = psc
        (UIApplication.sharedApplication().delegate as! AppDelegate).registerCoordinatorForStoreNotifications(psc)

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            let docURL = urls[urls.endIndex-1]
            /* The directory the application uses to store the Core Data store file.
            This code uses a file named "DataModel.sqlite" in the application's documents directory.
            */
            let localStoreURL = docURL.URLByAppendingPathComponent("TailorModel.sqlite")
            do {
                try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: localStoreURL, options: [
                    NSPersistentStoreUbiquitousContentNameKey: "TailorCloudStore",
                    NSMigratePersistentStoresAutomaticallyOption: true,
                    NSInferMappingModelAutomaticallyOption: true
                ])
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }

    }

    
    // MARK: - Habit Operations

    func fetchHabit(id: NSManagedObjectID, callback: ((habit: Habit?) -> Void)) {
        let habit = managedObjectContext.objectWithID(id) as? Habit
        callback(habit: habit)
    }

    func insertHabit(name: String, numDays: Int?, weekDays: Set<WeekDay>?, goal: String?) -> Habit {
        let habit = NSEntityDescription.insertNewObjectForEntityForName("Habit", inManagedObjectContext: self.managedObjectContext) as! Habit
        // set properties
        var dict: [String:AnyObject] = [
            "name": name
        ]

        if let nD = numDays {
            dict.updateValue(1, forKey: "useNumDays")
            dict.updateValue(nD, forKey: "numDays")
        }

        if let wD = weekDays {
            dict.updateValue(0, forKey: "useNumDays")
            dict.updateValue(wD.contains(.Sunday), forKey: "sunday")
            dict.updateValue(wD.contains(.Monday), forKey: "monday")
            dict.updateValue(wD.contains(.Tuesday), forKey: "tuesday")
            dict.updateValue(wD.contains(.Wednesday), forKey: "wednesday")
            dict.updateValue(wD.contains(.Thursday), forKey: "thursday")
            dict.updateValue(wD.contains(.Friday), forKey: "friday")
            dict.updateValue(wD.contains(.Saturday), forKey: "saturday")
        }

        if let g = goal {
            dict.updateValue(g, forKey: "goal")
        }

        // TODO: determine order based on max order within the list
        dict.updateValue(0, forKey: "order")
        habit.setValuesForKeysWithDictionary(dict)

        self.managedObjectContext.performBlock {
            do {
                try self.managedObjectContext.save()
                print("successfully added")
            } catch {
                fatalError("Failed to create habit: \(error)")
            }
        }

        return habit
    }

    func updateHabit(id: NSManagedObjectID, name: String?, numDays: Int?, weekDays: Set<WeekDay>?, goal: String?) -> Habit? {
        let habit = managedObjectContext.objectWithID(id) as? Habit

        var dict = [String:AnyObject]()
        if let n = name {
            dict.updateValue(n, forKey: "name")
        }

        if let nD = numDays {
            dict.updateValue(1, forKey: "useNumDays")
            dict.updateValue(nD, forKey: "numDays")
        }

        if let wD = weekDays {
            dict.updateValue(0, forKey: "useNumDays")
            dict.updateValue(wD.contains(.Sunday), forKey: "sunday")
            dict.updateValue(wD.contains(.Monday), forKey: "monday")
            dict.updateValue(wD.contains(.Tuesday), forKey: "tuesday")
            dict.updateValue(wD.contains(.Wednesday), forKey: "wednesday")
            dict.updateValue(wD.contains(.Thursday), forKey: "thursday")
            dict.updateValue(wD.contains(.Friday), forKey: "friday")
            dict.updateValue(wD.contains(.Saturday), forKey: "saturday")
        }

        if let g = goal {
            dict.updateValue(g, forKey: "goal")
        }

        // TODO: determine order based on max order within the list
        dict.updateValue(0, forKey: "order")
        habit?.setValuesForKeysWithDictionary(dict)

        self.managedObjectContext.performBlock {
            do {
                try self.managedObjectContext.save()
                print("successfully added")
            } catch {
                fatalError("Failed to update habit: \(error)")
            }
        }

        return habit
    }

    func deleteHabit(habit: Habit) {
        managedObjectContext.deleteObject(habit)

        self.managedObjectContext.performBlock {
            do {
                try self.managedObjectContext.save()
                print("successfully deleted")
            } catch {
                fatalError("Failed to delete habit: \(error)")
            }
        }
    }

    // MARK: - Entry Operations


    func insertEntry(habit: Habit, note: String? = nil) -> Entry {
        let entry = NSEntityDescription.insertNewObjectForEntityForName("Entry", inManagedObjectContext: self.managedObjectContext) as! Entry
        // set properties
        var dict = [String:AnyObject]()

        if let n = note {
            dict.updateValue(n, forKey: "note")
        }
        // TODO: determine order based on max order within the list
        entry.setValuesForKeysWithDictionary(dict)
        entry.habit = habit

        self.managedObjectContext.performBlock {
            do {
                try self.managedObjectContext.save()
                print("successfully added")
            } catch {
                fatalError("Failed to create habit: \(error)")
            }
        }

        return entry
    }

    func updateEntry(id: NSManagedObjectID, note: String? = nil) -> Entry? {
        let entry = managedObjectContext.objectWithID(id) as? Entry
        // set properties
        var dict = [String:AnyObject]()

        if let n = note {
            dict.updateValue(n, forKey: "note")
        }
        // TODO: determine order based on max order within the list
        entry?.setValuesForKeysWithDictionary(dict)

        self.managedObjectContext.performBlock {
            do {
                try self.managedObjectContext.save()
                print("successfully added")
            } catch {
                fatalError("Failed to update entry: \(error)")
            }
        }
        
        return entry
    }

    func deleteEntry(entry: Entry) {
        managedObjectContext.deleteObject(entry)

        self.managedObjectContext.performBlock {
            do {
                try self.managedObjectContext.save()
                print("successfully deleted")
            } catch {
                fatalError("Failed to delete entry: \(error)")
            }
        }
    }

}