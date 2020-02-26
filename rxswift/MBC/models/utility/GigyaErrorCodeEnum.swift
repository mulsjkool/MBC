//
//  GigyaCodeEnum.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/10/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

// swiftlint:disable number_separator
enum GigyaCodeEnum: Int {
    case accountsLinked = 200009
    case okWithErrorLoginIdentifierExists = 200010
    case accountPendingRegistration = 206001
    case accountPendingVerification = 206002
    case accountMissingLoginID = 206003
    case uniqueIdentifierExists = 400003
    case validation = 400009
    case loginFailedCaptchaRequired = 401020
    case oldPasswordUsed = 401030
    case unverifiedUser = 403013
    case accountDisabled = 403041
    case invalidLoginID = 403042
    case loginIdentifierExists = 403043
    case accountTemporarilyLockedOut = 403120
    case serverLoginError = 500002
    case loginIDDoesNotExist = 403047
    case permissionDenied = 403007
    case emailNotVerified = 400028
    case duplicateNonce = 403004
    case registrationError = -1000
    case facebookLoginCanceled = 200001
    case invalidRequestSignature = 403003
    case invalidParameterValue = 400006
    case requestHasExpired = 403002
    
    case internalServerError = 500001
    case successCode = 200
    case serverError = -1001
    case unknownError = -1002
    case networkError = 500026
    
    // swiftlint:disable:next cyclomatic_complexity
    func errorString() -> String? {
        switch self {
        case .accountsLinked:
            return ""
        case .okWithErrorLoginIdentifierExists:
            return ""
        case .accountPendingRegistration:
            return ""
        case .accountPendingVerification:
            return R.string.localizable.errorAccountPendingVerification()
        case .accountMissingLoginID:
            return ""
        case .uniqueIdentifierExists:
            return R.string.localizable.errorEmailHasExisted()
        case .validation:
            return ""
        case .loginFailedCaptchaRequired:
            return R.string.localizable.errorPasswordWrongManyTimes()
        case .oldPasswordUsed:
            return R.string.localizable.errorOldPasswordUsed()
        case .unverifiedUser:
            return ""
        case .accountDisabled:
            return R.string.localizable.errorAccountDisabled()
        case .invalidLoginID:
            return R.string.localizable.errorInvalidLoginID()
        case .loginIdentifierExists:
            return R.string.localizable.errorLoginIdentifierExists()
        case .accountTemporarilyLockedOut:
            return R.string.localizable.errorAccountIsBlocked()
        case .serverLoginError:
            return ""
        case .loginIDDoesNotExist:
            return R.string.localizable.errorLoginIDDoesNotExist()
        case .permissionDenied:
            return R.string.localizable.errorPermissionDenied()
        case .emailNotVerified:
            return R.string.localizable.errorEmailNotVerified()
        case .duplicateNonce:
            return ""
        case .registrationError:
            return R.string.localizable.errorRegistrationFail()
        case .facebookLoginCanceled:
            return ""
        case .invalidRequestSignature:
            return R.string.localizable.errorInvalidRequestSignature()
        case .invalidParameterValue:
            return R.string.localizable.errorInvalidParameterValue()
        case .requestHasExpired:
            return R.string.localizable.errorRequestHasExpired()
            
        case .networkError:
            return R.string.localizable.errorNetworkError()
        case .successCode:
            return ""
        case .serverError, .internalServerError:
            return R.string.localizable.errorServerError()
        case .unknownError:
            return R.string.localizable.errorUnknownError()
        }
    }
}
// swiftlint:enable number_separator
