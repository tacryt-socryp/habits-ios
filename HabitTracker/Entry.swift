//
//  Entry.swift
//  Tailor
//
//  Created by Logan Allen on 1/23/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import RealmSwift

// An Entry is an action that is categorized into habits.
class Entry: Object {

    dynamic var date = NSDate()
    dynamic var note = ""

}