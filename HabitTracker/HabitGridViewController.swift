//
//  HabitGridViewController.swift
//  Tailor
//
//  Created by Logan Allen on 2/22/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit

class HabitGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, AppViewController {

    var viewModel : HabitGridModel? = nil

    func setup(viewModel: ViewModel) {
        self.viewModel = viewModel as? HabitGridModel
        self.bindModel()
    }

    // use bond
    func bindModel() {
//        if let vm = self.viewModel {
//            // set your data!
//        }
    }

    // MARK: - App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "＋", style: .Plain, target: self, action: "addTapped")

        let space = 5.0 as CGFloat
        let flowLayout = UICollectionViewFlowLayout()
        // Set view cell size
        flowLayout.itemSize = CGSizeMake(50, 50)

        // Set left and right margins
        flowLayout.minimumInteritemSpacing = space

        // Set top and bottom margins
        flowLayout.minimumLineSpacing = space


        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.registerClass(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "collectionCell"
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.blackColor()


        self.view.addSubview(collectionView)
    }

    // MARK: - User Events
    func addTapped() {
        viewModel?.addTapped()
    }

    // MARK: - Collection View

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.appData?.allHabits.count ?? -1
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath)

        cell.backgroundColor = UIColor.greenColor()
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 50, bottom: 20, right: 50)
    }
}
