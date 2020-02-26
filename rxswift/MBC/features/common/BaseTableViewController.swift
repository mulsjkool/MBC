//
//  BaseTableViewController.swift
//  MBC
//
//  Created by Dao Le Quang on 11/17/16.
//  Copyright © 2016 MBC. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class BaseTableViewController: UITableViewController, ErrorDecorator {
    var disposeBag = DisposeBag()
    var isShowing = false
    var isShowLoading = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        isShowing = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        isShowing = false
    }

    func showError(message: String, completed: (() -> Void)?) {
        if isShowLoading {

        } else {
            alert(title: message, message: nil, completed: completed)
        }
    }

    func showMessage(message: String) {
        if isShowLoading {

        } else {
            showAlertWith(message: message)
        }
    }

    private func showAlertWith(message: String) {

    }

    func showConfirm(message: String, leftAction: AlertAction, rightAction: AlertAction) {

    }

    func showLoading(status: String) {
        isShowLoading = true

    }

    func hideLoading() {
        isShowLoading = false

    }

    func alert(title: String?, message: String?, completed: (() -> Void)?) {

    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
