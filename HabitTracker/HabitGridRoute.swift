//
//  HabitGridRoute.swift
//  Tailor
//
//  Created by Logan Allen on 2/23/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import Compass
import UIKit

struct HabitGridRoute: CustomRoutable {
    func resolve(arguments: [String: AnyObject], navigationController: UINavigationController, coordinator: AppCoordinator) {
        // guard let username = arguments["username"] else { return }

        let vC = HabitGridViewController()
        let viewModel = HabitGridModel(coordinator: coordinator)
        vC.setup(viewModel)

        navigationController.pushViewController(vC, animated: true)
    }
}