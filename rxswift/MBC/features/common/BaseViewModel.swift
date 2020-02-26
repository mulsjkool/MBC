//
//  BaseViewModel.swift
//  MBC
//
//  Created by Tuyen Nguyen Thanh on 10/3/16.
//  Copyright © 2016 MBC. All rights reserved.
//

import Foundation
import RxSwift

class BaseViewModel {
    var disposeBag = DisposeBag()
    weak var errorDecorator: ErrorDecorator?

    func showError(error: Error, completed: (() -> Void)? = nil) {
        errorDecorator?.showError(message: errorMessageFrom(type: error), completed: completed)
    }

    func showError(errorMessage: String, completed: (() -> Void)? = nil) {
        errorDecorator?.showError(message: errorMessage, completed: completed)
    }

    func errorMessageFrom(type errorType: Error) -> String {
        let message = ""

        return message
    }

    func showConfirm(message: String, leftAction: AlertAction, rightAction: AlertAction) {
        errorDecorator?.showConfirm(message: message, leftAction: leftAction, rightAction: rightAction)
    }
}
