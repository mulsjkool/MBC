//
//  ErrorDecorator.swift
//  MBC
//
//  Created by Tuyen Nguyen Thanh on 10/14/16.
//  Copyright © 2016 MBC. All rights reserved.
//

import Foundation
import UIKit

protocol ErrorDecorator: class {
    func showError(message: String, completed: (() -> Void)?)
    func showConfirm(message: String, leftAction: AlertAction, rightAction: AlertAction)
}
