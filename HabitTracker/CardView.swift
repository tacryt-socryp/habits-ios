//
//  CardView.swift
//  Tailor
//
//  Created by Logan Allen on 3/6/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit

class CardView: UICollectionViewCell {
    var cardData: CardData? = nil {
        didSet {
            self.setup()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func didMoveToSuperview() {
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }

    func setup() {
        if let cardType = cardData?.cardType {
            switch cardType {
            case .habitGridCard:
                (self as! HabitGridCardView).setup()
            case .lastSevenDaysCard:
                break
            case .none:
                break
            }
        }
    }
}