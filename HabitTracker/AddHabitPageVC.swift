//
//  AddHabitPageVC.swift
//  Tailor
//
//  Created by Logan Allen on 1/20/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import Foundation
import UIKit

// not in use, but I want to use a UIPageViewController for onboarding, so keeping this.
class AddHabitPageVC: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    var habitViewControllers: [UIViewController]? = nil
    var currentView: Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        self.configureView()
    }

    func configureView() {
        // values are from 0.0 to 1.0, not 0 to 255
        self.view?.backgroundColor = UIColor(red: 0.0, green: 151.0 / 255.0, blue: 167.0 / 255.0, alpha: 1.0)

        habitViewControllers = [UIViewController]()
        let viewController = self.storyboard?
            .instantiateViewControllerWithIdentifier(Constants.ViewControllers.addHabit) as! AddHabitViewController
        habitViewControllers!.append(viewController)
        self.setViewControllers(habitViewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        currentView = 0
    }

    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        // Returns the view controller before the given view controller.
        if (currentView != nil) && (currentView! != 0) {
            return habitViewControllers?[currentView! - 1]
        }
        return nil
    }

    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        // Returns the view controller after the given view controller.
        let numVCs = habitViewControllers?.count ?? 0
        print(numVCs)
        if (currentView != nil) && (currentView! < numVCs - 1) {
            print("returning next vc")
            return habitViewControllers?[currentView! + 1]
        }
        return nil
    }

}