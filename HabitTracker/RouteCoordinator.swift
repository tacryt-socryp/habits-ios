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
    case viewHabit = "viewHabit"
    case editHabit = "editHabit"
    case settings = "settings"
}

let compassRoutes: [String] = [
    "habitGrid",
    "createHabit",
    "viewHabit",
    "editHabit",
    "settings"
];

let routerRoutes: [String : CustomRoutable] = [
    (routesEnum.habitGrid.rawValue): HabitGridRoute(),
    (routesEnum.createHabit.rawValue): CreateHabitRoute(),
    (routesEnum.viewHabit.rawValue): ViewHabitRoute(),
    (routesEnum.editHabit.rawValue): ViewHabitRoute(),
    (routesEnum.settings.rawValue): SettingsRoute()
]

class RouteCoordinator: NSObject {

    private var appCoordinator: AppCoordinator!
    private var navigationController: UINavigationController!
    private var router: CustomRouter!
    var window: UIWindow!

    init(coordinator: AppCoordinator, window: UIWindow) {
        super.init()
        self.appCoordinator = coordinator
        self.window = window
        self.router = CustomRouter()
        navigationController = self.window.rootViewController as! UINavigationController
        navigationController?.navigationBar.setBackgroundImage(
            UIImage(),
            forBarMetrics: UIBarMetrics.Default
        )
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = UIColor.clearColor()

        // Set up Compass
        Compass.scheme = "compass"
        Compass.routes = compassRoutes
        router.routes = routerRoutes
    }

    func routeEnumToURL(route: routesEnum) -> NSURL {
        return NSURL(string: "\(Compass.scheme)\(route.rawValue)")!
    }

    func navigateToRoute(url: NSURL, options: [String : AnyObject]?) -> Bool {
        // if options specifies viewModel, use that. Otherwise, make one yourself!
        let result = Compass.parse(url) { route, arguments in
            self.router.navigate(route,
                arguments: arguments,
                navigationController: self.navigationController,
                coordinator: self.appCoordinator
            )
        }
        return result
    }

}