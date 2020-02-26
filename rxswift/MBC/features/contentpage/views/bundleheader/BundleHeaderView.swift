//
//  BundleHeaderView.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 2/27/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift
import UIKit
import MisterFusion

class BundleHeaderView: BaseView {
    
    // MARK: outlets
    @IBOutlet private var containerView: UIView!
    @IBOutlet weak private var bundleTitleLabel: UILabel!
    @IBOutlet weak private var pageControl: MBCPageControl!
    
    // Rx
    private let closeOnDemand = PublishSubject<Void>()
    
    // MARK: events
    @IBAction func closeButtonTouched(_ sender: Any) {
        closeOnDemand.onNext(())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: Public functions
    
    // Properties
    var didTapCloseButton: Observable<Void> { return closeOnDemand.asObserver() }
    var headerTitle: String = "" {
        didSet { bundleTitleLabel.text = headerTitle }
    }
    var pagerControl: MBCPageControl { return pageControl }
    
    // MARK: Private functions
    private func commonInit() {
        Bundle.main.loadNibNamed(R.nib.bundleHeaderView.name, owner: self, options: nil)
        addSubview(containerView)
        pageControl.backgroundColor = UIColor.clear
        pageControl.currentPageTintColor = Colors.white.color()
//        pageControl.inactiveTintColor = Colors.black.color(alpha: 0.4)
        pageControl.radius = 1.5
        pageControl.padding = 4
        containerView.frame = self.bounds
        self.mf.addConstraints([
            self.top |==| containerView.top,
            self.left |==| containerView.left,
            self.bottom |==| containerView.bottom,
            self.right |==| containerView.right
        ])
        
        pageControl.isUserInteractionEnabled = false
    }
}
