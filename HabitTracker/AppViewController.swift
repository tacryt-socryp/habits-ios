//
//  AppViewController.swift
//  Tailor
//
//  Created by Logan Allen on 2/22/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//


protocol AppViewController {

    var appCoordinator : AppCoordinator? { get set}

    var viewModel : ViewModel? { get set}

    func setup(viewModel: ViewModel)

    // use bond
    func bindModel() -> Bool
    
}