//
//  ViewModel.swift
//  Tailor
//
//  Created by Logan Allen on 2/22/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import Foundation

protocol ViewModelProtocol {

    /// the AppCoordinator that manages this view model
    var coordinator: AppCoordinator { get }
    var routeCoordinator: RouteCoordinator { get }
}

class ViewModel : NSObject, ViewModelProtocol {

    let coordinator: AppCoordinator
    let routeCoordinator: RouteCoordinator
    var appData: AppDataService? = nil

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        appData = self.coordinator.databaseCoordinator.appDataService
        routeCoordinator = self.coordinator.routeCoordinator
    }
}