//
//  SchedulerDaySelectionItemView.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 3/14/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import MisterFusion

class SchedulerDaySelectionItemView: UIView {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var dayLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: Public
    func bindData(day: String) {
        self.dayLabel.text = day
    }
    
    // MARK: Private
    private func commonInit() {
        Bundle.main.loadNibNamed(R.nib.schedulerDaySelectionItemView.name, owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        self.mf.addConstraints([
            self.top |==| containerView.top,
            self.left |==| containerView.left,
            self.bottom |==| containerView.bottom,
            self.right |==| containerView.right
        ])
    }

}
