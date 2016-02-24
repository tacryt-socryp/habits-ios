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
}

class ViewModel : NSObject, ViewModelProtocol {

    let coordinator: AppCoordinator

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
}