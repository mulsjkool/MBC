//
//  LabelFormCell.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 3/28/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class LabelFormCell: BaseTableViewCell {
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    
    func bindData(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
