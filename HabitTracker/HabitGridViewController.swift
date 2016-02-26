//
//  HabitGridViewController.swift
//  Tailor
//
//  Created by Logan Allen on 2/22/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit

class HabitGridViewController: UIViewController, UICollectionViewDelegate, AppViewController {

    var collectionView: UICollectionView? = nil {
        didSet {
            self.bindModel()
        }
    }
    var viewModel : HabitGridModel? = nil

    func setup(viewModel: ViewModel) {
        self.viewModel = viewModel as? HabitGridModel
    }

    // use bond
    func bindModel() {
        if (collectionView == nil) { return }
        viewModel?.appData?.allHabits.lift().bindTo(collectionView!) { indexPath, array, collectionView in
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath)

            cell.backgroundColor = UIColor.greenColor()
            return cell
        }

        /*let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! RepositoryCell
        let repository = array[indexPath.section][indexPath.item]

        repository.name
        .bindTo(cell.nameLabel.bnd_text)
        .disposeIn(cell.onReuseBag)

        repository.photo
        .bindTo(cell.avatarImageView.bnd_image)
        .disposeIn(cell.onReuseBag)

        return cell*/
        // set your data!
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


        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView!.registerClass(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "collectionCell"
        )
        collectionView!.delegate = self
        collectionView!.backgroundColor = UIColor.blackColor()

        self.view.addSubview(collectionView!)
    }

    // MARK: - User Events
    func addTapped() {
        viewModel?.addTapped()
    }

    // MARK: - Collection View

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 50, bottom: 20, right: 50)
    }
}
