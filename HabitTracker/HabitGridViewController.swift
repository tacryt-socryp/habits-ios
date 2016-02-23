//
//  HabitGridViewController.swift
//  Tailor
//
//  Created by Logan Allen on 2/22/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit

class HabitGridViewController: UICollectionViewController, AppViewController {

    var appCoordinator : AppCoordinator? = nil

    var model : ViewModel? = nil

    // use bond
    func bindModel() -> Bool {
        let vm = self.model as! HabitGridModel
        return false
    }
}
