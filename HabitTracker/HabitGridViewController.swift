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

    var viewModel : ViewModel? = nil

    func setup(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // use bond
    func bindModel() -> Bool {
        let vm = self.viewModel as! HabitGridModel
        return false
    }
}
