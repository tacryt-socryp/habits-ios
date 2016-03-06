//
//  SingleHabitViewController.swift
//  Tailor
//
//  Created by Logan Allen on 3/4/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//


import UIKit
import Bond

class SingleHabitViewController: UIViewController, UICollectionViewDelegate, AppViewController {

    var collectionView: UICollectionView? = nil {
        didSet {
            self.bindModel()
        }
    }
    var viewModel : SingleHabitModel? = nil

    func setup(viewModel: ViewModel) {
        self.viewModel = viewModel as? SingleHabitModel
        self.viewModel?.setup()
    }

    // use bond
    func bindModel() {
        if (collectionView == nil) { return }
        viewModel?.allCards.lift().bindTo(collectionView!) { indexPath, array, collectionView in
            // initialize a CardView
            // pass in a CardData object to CardView
            // call setup on CardView, which calls setup on CardData, which adds views to itself
            let cardData = array[indexPath.section][indexPath.row]
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CardCell", forIndexPath: indexPath) as! CardView

            cell.cardData = cardData

            return cell
        }
    }

    // MARK: - App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let space = 15.0 as CGFloat
        let flowLayout = UICollectionViewFlowLayout()
        // Set view cell size
        flowLayout.itemSize = CGSizeMake(165, 165)

        // Set left and right margins
        flowLayout.minimumInteritemSpacing = space

        // Set top and bottom margins
        flowLayout.minimumLineSpacing = space

        // spacing within a section
        flowLayout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)


        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView?.registerClass(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "collectionCell"
        )
        collectionView?.delegate = self

        // TODO: set this programmatically based on the animal
        collectionView?.backgroundColor = Constants.Colors.skyBlueBackground
        // register the different types of habit cards
        collectionView?.registerNib(UINib(
            nibName: "HabitGridCard",
            bundle: nil
            ), forCellWithReuseIdentifier: "CardCell")

        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
        let pressRecognizer = UILongPressGestureRecognizer(target: self, action: "handlePress:")

        collectionView?.addGestureRecognizer(tapRecognizer)
        collectionView?.addGestureRecognizer(pressRecognizer)

        self.view.addSubview(collectionView!)
    }

    // MARK: - User Events

    func getIndexForLocation(gesture: UITapGestureRecognizer) -> NSIndexPath? {
        return collectionView?.indexPathForItemAtPoint(gesture.locationInView(collectionView))
    }

    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended, let index = self.getIndexForLocation(sender) {
            viewModel?.handleCollectionTapped(index)
        }
    }

    func handlePress(sender: UITapGestureRecognizer) {
        if sender.state == .Ended, let index = self.getIndexForLocation(sender) {
            viewModel?.handleCollectionPressed(index)
        }
    }
    
}