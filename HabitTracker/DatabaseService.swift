//
//  DatabaseService.swift
//  Tailor
//
//  Created by Logan Allen on 2/22/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import CoreData

class DatabaseService {

    var coordinator: CoreDataCoordinator!
    var persistentStoreCoordinator: NSPersistentStoreCoordinator
    var managedObjectContext: NSManagedObjectContext
    var managedObjectModel: NSManagedObjectModel

    let allHabitsFetch: NSFetchRequest = {
        let fetchRequest = NSFetchRequest(entityName: "Habit")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "needsAction", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        return fetchRequest
    }()

    let fetchTemplates: [String : NSFetchRequest]

    init(coordinator: CoreDataCoordinator) {
        self.coordinator = coordinator
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = NSBundle.mainBundle().URLForResource("DataModel", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }

        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        managedObjectModel = mom
        fetchTemplates = [
            "allHabits": allHabitsFetch
        ]

        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator

        coordinator.registerCoordinatorForStoreNotifications(persistentStoreCoordinator, objectContext: managedObjectContext)

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            let docURL = urls[urls.endIndex-1]
            /* The directory the application uses to store the Core Data store file.
            This code uses a file named "DataModel.sqlite" in the application's documents directory.
            */
            let localStoreURL = docURL.URLByAppendingPathComponent("DataModel.sqlite")
            do {
                try self.persistentStoreCoordinator.addPersistentStoreWithType(
                    NSSQLiteStoreType,
                    configuration: nil,
                    URL: localStoreURL,
                    options: [
                        NSPersistentStoreUbiquitousContentNameKey: "DataCloudStore",
                        NSMigratePersistentStoresAutomaticallyOption: true,
                        NSInferMappingModelAutomaticallyOption: true
                    ])
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }

    func deleteAllHabits() {
        let fetchRequest = NSFetchRequest(entityName: "Habit")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try self.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.managedObjectContext)
        } catch {
            // TODO: handle the error
        }
    }


    // MARK: - Habit Operations

    func fetchAllHabits(callback: ((habits: [Habit]) -> Void)) {
        let request = self.fetchTemplates["allHabits"]!

        self.managedObjectContext.performBlock {
            do {
                let habits = try self.managedObjectContext.executeFetchRequest(request) as! [Habit]
                callback(habits: habits)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }

    }

    func fetchHabit(id: NSManagedObjectID, callback: ((habit: Habit?) -> Void)) {
        self.managedObjectContext.performBlock {
            let habit = self.managedObjectContext.objectWithID(id) as? Habit
            callback(habit: habit)
        }
    }

    func insertHabit(name: String, weekDays: Set<WeekDay>?) -> Habit {
        let habit = NSEntityDescription.insertNewObjectForEntityForName("Habit", inManagedObjectContext: self.managedObjectContext) as! Habit
        // set properties
        var dict: [String:AnyObject] = [
            "name": name
        ]

        if let wD = weekDays {
            dict.updateValue(wD.contains(.Sunday), forKey: "sunday")
            dict.updateValue(wD.contains(.Monday), forKey: "monday")
            dict.updateValue(wD.contains(.Tuesday), forKey: "tuesday")
            dict.updateValue(wD.contains(.Wednesday), forKey: "wednesday")
            dict.updateValue(wD.contains(.Thursday), forKey: "thursday")
            dict.updateValue(wD.contains(.Friday), forKey: "friday")
            dict.updateValue(wD.contains(.Saturday), forKey: "saturday")
        }

        dict.updateValue(0, forKey: "needsAction")
        habit.setValuesForKeysWithDictionary(dict)

        self.managedObjectContext.performBlock {
            do {
                try self.managedObjectContext.save()
            } catch {
                fatalError("Failed to create habit: \(error)")
            }
        }

        return habit
    }

    func updateHabit(id: NSManagedObjectID,
        name: String? = nil,
        weekDays: Set<WeekDay>? = nil
        ) -> Habit? {

            let habit = managedObjectContext.objectWithID(id) as? Habit

            var dict = [String:AnyObject]()
            if let n = name {
                dict.updateValue(n, forKey: "name")
            }

            if let wD = weekDays {
                dict.updateValue(wD.contains(.Sunday), forKey: "sunday")
                dict.updateValue(wD.contains(.Monday), forKey: "monday")
                dict.updateValue(wD.contains(.Tuesday), forKey: "tuesday")
                dict.updateValue(wD.contains(.Wednesday), forKey: "wednesday")
                dict.updateValue(wD.contains(.Thursday), forKey: "thursday")
                dict.updateValue(wD.contains(.Friday), forKey: "friday")
                dict.updateValue(wD.contains(.Saturday), forKey: "saturday")
            }

            habit?.setValuesForKeysWithDictionary(dict)

            self.managedObjectContext.performBlock {
                do {
                    try self.managedObjectContext.save()
                } catch {
                    fatalError("Failed to update habit: \(error)")
                }
            }

            return habit
    }

    func setHabitNeedsAction(id: NSManagedObjectID) {
        let habit = managedObjectContext.objectWithID(id) as? Habit

        if let isTodayComplete = habit?.isTodayComplete {

            habit?.needsAction = !isTodayComplete

            self.managedObjectContext.performBlock {
                do {
                    try self.managedObjectContext.save()
                } catch {
                    fatalError("Failed to update habit: \(error)")
                }
            }

        }
    }

    func deleteHabit(habit: Habit) {
        managedObjectContext.deleteObject(habit)

        self.managedObjectContext.performBlock {
            do {
                try self.managedObjectContext.save()
                self.triggersDidChange()
            } catch {
                fatalError("Failed to delete habit: \(error)")
            }
        }
    }


    // MARK: - Trigger Operations

    func fetchAllTriggers(callback: ((triggers: [NSManagedObject]) -> Void)) {
        let request = NSFetchRequest(entityName: "Trigger")
        request.includesSubentities = true

        self.managedObjectContext.performBlock {
            do {
                let triggers = try self.managedObjectContext.executeFetchRequest(request) as! [NSManagedObject]
                callback(triggers: triggers)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }

    func insertTrigger(
        habit: Habit,
        data: AnyObject,
        type: TriggerTypes,
        reminderText: String? = nil
        ) {
            let entityName = TriggerTypeToEntityName[type]!
            let trigger = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: self.managedObjectContext)

            // set properties
            var dict = [String:AnyObject]()

            dict.updateValue(data, forKey: "data")
            dict.updateValue(type.rawValue, forKey: "type")
            dict.updateValue(habit, forKey: "habit")

            if let rT = reminderText {
                dict.updateValue(rT, forKey: "reminderText")
            }

            trigger.setValuesForKeysWithDictionary(dict)

            self.managedObjectContext.performBlock {
                do {
                    try self.managedObjectContext.save()
                    self.triggersDidChange()
                } catch {
                    fatalError("Failed to create trigger: \(error)")
                }
            }
    }

    func updateTrigger(
        id: NSManagedObjectID,
        data: AnyObject? = nil,
        reminderText: String? = nil
        ) {
            let trigger = managedObjectContext.objectWithID(id)

            // set properties
            var dict = [String:AnyObject]()
            if let rT = reminderText {
                dict.updateValue(rT, forKey: "reminderText")
            }
            if let d = data {
                dict.updateValue(d, forKey: "data")
            }

            trigger.setValuesForKeysWithDictionary(dict)

            self.managedObjectContext.performBlock {
                do {
                    try self.managedObjectContext.save()
                    self.triggersDidChange()
                } catch {
                    fatalError("Failed to update trigger: \(error)")
                }
            }
    }

    func deleteTrigger(id: NSManagedObjectID) {
        let trigger = managedObjectContext.objectWithID(id)
        managedObjectContext.deleteObject(trigger)

        self.managedObjectContext.performBlock {
            do {
                try self.managedObjectContext.save()
                self.triggersDidChange()
            } catch {
                fatalError("Failed to delete trigger: \(error)")
            }
        }
    }

    func triggersDidChange() {
        self.coordinator.shouldResetLocalNotifications()
    }


    // MARK: - Entry Operations

    func insertEntry(habit: Habit, note: String? = nil) -> Entry {
        let entry = NSEntityDescription.insertNewObjectForEntityForName("Entry", inManagedObjectContext: self.managedObjectContext) as! Entry

        // set properties
        var dict = [String:AnyObject]()

        if let n = note {
            dict.updateValue(n, forKey: "note")
        }
        entry.setValuesForKeysWithDictionary(dict)
        entry.habit = habit

        self.managedObjectContext.performBlock {
            do {
                try self.managedObjectContext.save()
            } catch {
                fatalError("Failed to create entry: \(error)")
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
        entry?.setValuesForKeysWithDictionary(dict)
        
        self.managedObjectContext.performBlock {
            do {
                try self.managedObjectContext.save()
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
            } catch {
                fatalError("Failed to delete entry: \(error)")
            }
        }
    }

}