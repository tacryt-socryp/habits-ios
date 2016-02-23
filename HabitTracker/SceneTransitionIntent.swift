//
//  SceneTransitionIntent.swift
//  Tailor
//
//  Created by Logan Allen on 2/22/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

enum SceneMethodEnum {
    case Push
}

enum ControllerEnum {
    case HabitGrid
}


class SceneTransitionIntent {
    var method: SceneMethodEnum!
    var controller: ControllerEnum!

    init(method: SceneMethodEnum, controller: ControllerEnum) {
        self.method = method
        self.controller = controller
    }
}