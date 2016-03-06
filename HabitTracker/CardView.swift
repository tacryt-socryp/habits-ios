//
//  CardView.swift
//  Tailor
//
//  Created by Logan Allen on 3/6/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit

class CardView: UICollectionViewCell {
    var cardData: CardData? = nil

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func didMoveToSuperview() {
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }

    func setup() {
        print("don't call this; its a stub")
    }
}