//
//  CustomRouter.swift
//  Tailor
//
//  Created by Logan Allen on 2/23/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit

struct CustomRouter {

    var routes = [String: CustomRoutable]()

    init() {}

    func navigate(route: String, arguments: [String: AnyObject], navigationController: UINavigationController, coordinator: AppCoordinator) {
        guard let route = routes[route] else { return }

        route.resolve(arguments, navigationController: navigationController, coordinator: coordinator)
    }
}