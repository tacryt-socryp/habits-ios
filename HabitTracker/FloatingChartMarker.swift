//
//  FloatingChartMarker.swift
//  Tailor
//
//  Created by Logan Allen on 2/16/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit
import Charts

public class FloatingChartMarker: ChartMarker {

    public var textLabel: NSString? = nil

    public override var size: CGSize {
        return CGSize(width: 6, height: 6)
    }

    public override func draw(context context: CGContext, point: CGPoint) {
        CGContextSaveGState(context)

        if let text = textLabel {
            let attributes: NSDictionary = [
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSObliquenessAttributeName: 0.1,
                NSFontAttributeName: UIFont.systemFontOfSize(17)
            ]
            text.drawAtPoint(CGPoint(x: point.x, y: point.y), withAttributes: (attributes as! [String:AnyObject]))
        }

        CGContextSetLineWidth(context, 1.0)
        CGContextSetFillColorWithColor(context, UIColor.blueColor().CGColor)
        CGContextAddArc(context, point.x, point.y, 3.0, 0.0, CGFloat(M_PI * 2.0), 0)
        CGContextFillPath(context)

        CGContextRestoreGState(context)
    }
}