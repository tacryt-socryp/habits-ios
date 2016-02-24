//
//  SettingsRoute.swift
//  Tailor
//
//  Created by Logan Allen on 2/23/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import Compass
import UIKit

struct SettingsRoute: CustomRoutable {
    func resolve(arguments: [String: AnyObject], navigationController: UINavigationController, coordinator: AppCoordinator) {
        let habitGridController = HabitGridViewController()
        navigationController.pushViewController(habitGridController, animated: true)
    }
}