//
//  AboutTabLocationCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/15/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import UIKit

class AboutTabLocationCell: BaseTableViewCell {
    
    @IBOutlet weak private var webView: UIWebView!
    
    func bindData(locationUrl: String) {
        if let url = URL(string: locationUrl) {
            webView.loadRequest(URLRequest(url: url))
        }
    }
}
