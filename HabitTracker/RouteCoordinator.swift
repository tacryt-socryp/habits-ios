//
//  RouteCoordinator.swift
//  Tailor
//
//  Created by Logan Allen on 2/23/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit
import Compass

enum routesEnum: String {
    case habitGrid = "habitGrid"
    case createHabit = "createHabit"
    case viewHabit = "viewHabit:{habit}"
    case editHabit = "editHabit:{habit}"
    case settings = "settings"
}

let routes: [String : CustomRoutable] = [
    (routesEnum.habitGrid.rawValue): HabitGridRoute(),
    (routesEnum.createHabit.rawValue): CreateHabitRoute(),
    (routesEnum.viewHabit.rawValue): ViewHabitRoute(),
    (routesEnum.editHabit.rawValue): ViewHabitRoute(),
    (routesEnum.settings.rawValue): SettingsRoute()
]

class RouteCoordinator: NSObject {

    private var appCoordinator: AppCoordinator!
    private var window: UIWindow!
    private var navigationController: UINavigationController!
    private var router: CustomRouter!

    init(coordinator: AppCoordinator, window: UIWindow) {
        super.init()
        self.appCoordinator = coordinator
        self.window = window
        self.router = CustomRouter()
        print(self.window.rootViewController)
        navigationController = self.window.rootViewController as! UINavigationController

        router.routes = routes
    }

    func navigateToRoute(url: NSURL, options: [String : AnyObject]?) -> Bool {
        // if options specifies viewModel, use that. Otherwise, make one yourself!
        return Compass.parse(url) { route, arguments in
            self.router.navigate(route,
                arguments: arguments,
                navigationController: self.navigationController,
                coordinator: self.appCoordinator
            )
        }
    }

}