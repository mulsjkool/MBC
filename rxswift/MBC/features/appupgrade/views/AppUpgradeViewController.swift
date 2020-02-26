//
//  AppUpgradeViewController.swift
//  MBC
//
//  Created by admin on 3/21/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class AppUpgradeViewController: BaseViewController {

    @IBOutlet weak private var updateButton: UIButton!
    @IBOutlet weak private var messageLabel: UILabel!
    @IBOutlet weak private var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func config(hideSkipButton: Bool, message: String) {
        messageLabel.text = message
        skipButton.isHidden = hideSkipButton
        updateButton.setTitle(R.string.localizable.appupdateButtonUpdate(), for: .normal)
        skipButton.setTitle(R.string.localizable.appupdateButtonSkip(), for: .normal)
    }
    
    // MARK: - Action method
    @IBAction func updatePressed(_ sender: Any) {
        let url = URL(string: Constants.DefaultValue.addressUpdateApp)
        UIApplication.shared.openURL(url!)
    }
    
    @IBAction func skipPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }

}
