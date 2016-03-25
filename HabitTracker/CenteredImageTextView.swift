//
//  CenteredImageTextView.swift
//  Tailor
//
//  Created by Logan Allen on 3/24/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit

class CenteredImageTextView : UIView {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textLabel: UILabel!

    static func instanceFromNib() -> UIView {
        return UINib(nibName: "CenteredImageTextView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
}
