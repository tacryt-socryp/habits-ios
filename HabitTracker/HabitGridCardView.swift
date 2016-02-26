//
//  HabitGridCardView.swift
//  Tailor
//
//  Created by Logan Allen on 2/25/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit

class HabitGridCardView: UICollectionViewCell {

    @IBOutlet var habitName: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func didMoveToSuperview() {
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}