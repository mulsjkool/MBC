//
//  MBCPagerControl.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 3/3/18.
//  Copyright © 2018 MBC. All rights reserved.
//

// this control is heavily inspired by ISPageControl
// https://github.com/Interactive-Studio/ISPageControl

import UIKit

open class MBCPageControl: UIControl {
    fileprivate var dotLayers: [CALayer] = []
    fileprivate var diameter: CGFloat { return radius * 2 }
    fileprivate var lastScreenBounds: CGRect = CGRect()
    
    fileprivate var displayingRange: ClosedRange = 0...1
    open var displayCount: Int = 8 { didSet { displayingRange = 0...displayCount-1 } }
    
    open var currentPage = 0 {
        didSet {
            guard numberOfPages > currentPage else { return }
            update()
        }
    }
    
    @IBInspectable open var inactiveTintColor: UIColor = UIColor.lightGray {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable open var currentPageTintColor: UIColor = #colorLiteral(red: 0, green: 0.6276981994, blue: 1, alpha: 1) {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable open var radius: CGFloat = 5 {
        didSet { updateDotLayersLayout() }
    }
    
    @IBInspectable open var padding: CGFloat = 8 {
        didSet { updateDotLayersLayout() }
    }
    
    @IBInspectable open var minScaleValue: CGFloat = 0.4 {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable open var middleScaleValue: CGFloat = 0.7 {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable open var numberOfPages: Int = 0 {
        didSet {
            setupDotLayers()
            isHidden = hideForSinglePage && numberOfPages <= 1
        }
    }
    
    @IBInspectable open var hideForSinglePage: Bool = true {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable open var inactiveTransparency: CGFloat = 0.4 {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable open var dotBorderWidth: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable open var dotBorderColor: UIColor = UIColor.clear {
        didSet { setNeedsLayout() }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required public init(frame: CGRect, numberOfPages: Int) {
        super.init(frame: frame)
        self.numberOfPages = numberOfPages
        setupDotLayers()
    }
    
    override open var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize.zero)
    }
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        let minValue = min(displayCount, numberOfPages)
        return CGSize(width: CGFloat(minValue) * diameter + CGFloat(minValue - 1) * padding, height: diameter)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if bounds != lastScreenBounds {
            lastScreenBounds = bounds
            updateDotLayersLayout()
        }
        
        dotLayers.forEach {
            if borderWidth > 0 {
                $0.borderWidth = dotBorderWidth
                $0.borderColor = dotBorderColor.cgColor
            }
        }
        
        update()
    }
}

private extension MBCPageControl {
    
    func setupDotLayers() {
        dotLayers.forEach{ $0.removeFromSuperlayer() }
        dotLayers.removeAll()
        
        (0..<numberOfPages).forEach { _ in
            let dotLayer = CALayer()
            layer.addSublayer(dotLayer)
            dotLayers.append(dotLayer)
        }
        
        updateDotLayersLayout() // 이부분은 변경이 필요할듯
        setNeedsLayout()
        invalidateIntrinsicContentSize()
    }
    
    func updateDotLayersLayout() {
        let floatCount = CGFloat(min(displayCount, numberOfPages))
        let displayWidth = diameter * floatCount + padding * (floatCount - 1)
        // 2x + displayWidth = screenWidth
        // x = (screenWidth - displayWidth) / 2
        let x = (bounds.size.width - displayWidth) * 0.5
        let y = (bounds.size.height - diameter) * 0.5
        var frame = CGRect(x: x, y: y, width: diameter, height: diameter)
        
        dotLayers.forEach {
            $0.cornerRadius = radius
            $0.frame = frame
            frame.origin.x += diameter + padding
        }
        
        if displayingRange.lowerBound > 0 {
            dotLayers.forEach {
                $0.frame.origin.x -= (diameter + padding) * CGFloat(displayingRange.lowerBound)
                //print("\(Date()) ktest-\($0.frame.origin.x)")
            }
            //print("\(Date()) ktest-end of shifting")
        }
    }
    
    func setupDotLayersPosition() {
        var movingOffset: CGFloat = 0
        if displayingRange.lowerBound == currentPage {
            if currentPage > 0 { movingOffset = diameter + padding }
        } else if displayingRange.upperBound == currentPage {
            if currentPage < numberOfPages - 1 { movingOffset = -(diameter + padding) }
        }
        guard movingOffset > 0 else { return }
        dotLayers.enumerated().forEach {
            $0.element.position = CGPoint(x: $0.element.position.x + movingOffset, y: $0.element.position.y)
        }
    }
    
    func setupDotLayersScale() {
        dotLayers.enumerated().forEach { $0.element.isHidden = !displayingRange.contains($0.offset) }
    }
    
    func update() {
        dotLayers.enumerated().forEach() {
            $0.element.backgroundColor = $0.offset == currentPage
                ? currentPageTintColor.cgColor
                : inactiveTintColor.withAlphaComponent(inactiveTransparency).cgColor
        }
        
        guard numberOfPages > displayCount else { return }
        
        changeFullScaleIndexsIfNeeded()
        setupDotLayersPosition()
        setupDotLayersScale()
    }
    
    private func getMovingOffset()  -> CGFloat {
        var movingOffset: CGFloat = 0
        if displayingRange.lowerBound == currentPage {
            if currentPage > 0 {
                displayingRange = displayingRange.lowerBound-1...displayingRange.upperBound-1
                movingOffset = (diameter + padding)
            }
        } else if displayingRange.upperBound == currentPage {
            if currentPage < numberOfPages - 1 {
                displayingRange = displayingRange.lowerBound+1...displayingRange.upperBound+1
                movingOffset = -(diameter + padding)
            }
        } else if displayingRange.upperBound < currentPage {
            displayingRange = displayingRange.lowerBound+1...displayingRange.upperBound+1
            return -(diameter + padding) + getMovingOffset()
        } else if displayingRange.lowerBound > currentPage {
            displayingRange = displayingRange.lowerBound-1...displayingRange.upperBound-1
            return (diameter + padding) + getMovingOffset()
        }
        
        return movingOffset
    }
    
    func changeFullScaleIndexsIfNeeded() {
        let movingOffset = getMovingOffset()
        guard movingOffset != 0 else { return }
        dotLayers.enumerated().forEach {
            $0.element.position = CGPoint(x: $0.element.position.x + movingOffset, y: $0.element.position.y)
            //print("\(Date()) ktest-\($0.element.position)")
        }
        //print("\(Date()) ktest-end of changing scale")
    }
}

