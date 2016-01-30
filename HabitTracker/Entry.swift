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
    
    @NSManaged var note: String?
    @NSManaged var date: NSDate?
    @NSManaged var habit: Habit?

    override func awakeFromInsert() {
        super.awakeFromInsert()
        self.date = NSDate()
    }

}
