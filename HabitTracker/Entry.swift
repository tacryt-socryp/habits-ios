//
//  Entry.swift
//  Tailor
//
//  Created by Logan Allen on 1/29/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import Foundation
import CoreData


class Entry: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

}

extension Entry {

    @NSManaged var note: String?
    @NSManaged var date: NSDate?
    @NSManaged var habit: Habit?
    
}
