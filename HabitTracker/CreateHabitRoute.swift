//
//  CreateHabitRoute.swift
//  Tailor
//
//  Created by Logan Allen on 2/23/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import Compass
import UIKit

struct CreateHabitRoute: CustomRoutable {
    func resolve(arguments: [String: AnyObject], navigationController: UINavigationController, coordinator: AppCoordinator) {

        let storyboard = navigationController.storyboard
        let vC = storyboard?.instantiateViewControllerWithIdentifier("createHabitVC") as! CreateHabitViewController
        let viewModel = CreateHabitModel(coordinator: coordinator)
        vC.setup(viewModel)

        navigationController.pushViewController(vC, animated: true)
    }
}