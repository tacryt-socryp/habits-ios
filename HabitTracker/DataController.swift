//
//  DataController.swift
//  Tailor
//
//  Created by Logan Allen on 1/29/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

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

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            let docURL = urls[urls.endIndex-1]
            /* The directory the application uses to store the Core Data store file.
            This code uses a file named "DataModel.sqlite" in the application's documents directory.
            */
            let localStoreURL = docURL.URLByAppendingPathComponent("TailorModel.sqlite")
            do {
                try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: localStoreURL, options: [
                    NSPersistentStoreUbiquitousContentNameKey: "TailorCloudStore"
                ])
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }

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

        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        return habit
    }

    func fetchObjects() -> [Habit]? {
        let habitsFetch = NSFetchRequest(entityName: "Habit")
        // habitsFetch.predicate = NSPredicate(format: "name == %@", firstName) // can filter results using predicates

        do {
            let fetchedHabits = try self.managedObjectContext.executeFetchRequest(habitsFetch) as! [Habit]
            return fetchedHabits
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        return nil
    }
    
}