//
//  SeekTimeSlider.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 2/3/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

open class SeekTimeSlider: UISlider {

    @IBInspectable open var trackWidth: CGFloat = 2 {
        didSet { setNeedsDisplay() }
    }
    
    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
        let defaultBounds = super.trackRect(forBounds: bounds)
        return CGRect(
            x: defaultBounds.origin.x,
            y: defaultBounds.origin.y + defaultBounds.size.height / 2 - trackWidth / 2,
            width: defaultBounds.size.width,
            height: trackWidth
        )
    }
    
    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        var position = touch.location(in: self).x
        let trackWidth = trackRect(forBounds: self.bounds).size.width
        if Constants.DefaultValue.shouldRightToLeft {
            /// due to transformation
            position = abs(position - trackWidth)
        }
        let value = Float(position / trackWidth)
        self.setValue(value, animated: false)
        super.sendActions(for: UIControlEvents.valueChanged)
        return true
    }
}
