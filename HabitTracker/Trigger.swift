//
//  Trigger.swift
//  Tailor
//
//  Created by Logan Allen on 2/16/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import CoreData
import UIKit

enum TriggerTypes: Int {
    case Time
}

class Trigger: NSManagedObject {
    
    @NSManaged var data: AnyObject // Transformable: MUST BE AN NSDictionary
    @NSManaged var type: NSNumber
    @NSManaged var habit: Habit
    
    @NSManaged var reminderText: String?

    func parseFromData() {
        print("stub function, not implemented")
    }

    func createLocalNotifications() -> [UILocalNotification?] {
        print("stub function, not implemented")
        return []
    }

}
