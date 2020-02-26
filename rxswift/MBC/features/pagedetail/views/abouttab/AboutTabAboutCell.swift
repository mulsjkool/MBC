//
//  AboutTabAboutCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/18/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import UIKit

class AboutTabAboutCell: BaseTableViewCell {
    @IBOutlet weak private var aboutLabel: UILabel!
    @IBOutlet weak private var titleLabel: UILabel!
    
    func bindData(pageInforAbout: PageInforAbout) {
        aboutLabel.text = pageInforAbout.aboutText
        titleLabel.text = pageInforAbout.title
        layoutIfNeeded()
    }
}
