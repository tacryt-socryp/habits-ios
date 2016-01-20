//
//  AddHabitPageVC.swift
//  Tailor
//
//  Created by Logan Allen on 1/20/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import Foundation
import UIKit

class AddHabitPageVC: UIPageViewController, UIPageViewControllerDataSource {

    

    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            // Returns the view controller before the given view controller.
            return nil
    }

    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
            // Returns the view controller after the given view controller.
            return nil
    }

    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        // support page indicator, return count for number of pages
        return 0
    }

    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        // support page indicator, return current page index
        return 0
    }

}