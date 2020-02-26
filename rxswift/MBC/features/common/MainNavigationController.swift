//
//  MainNavigationController.swift
//  MBC
//
//  Created by Tuyen Nguyen Thanh on 10/4/16.
//  Copyright © 2016 MBC. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Common.setupNavigationBar(self.navigationBar)

        if let vc = viewControllers.first as? BaseViewController {
            vc.navigator = Navigator(navigationController: self)
        }
    }
}
