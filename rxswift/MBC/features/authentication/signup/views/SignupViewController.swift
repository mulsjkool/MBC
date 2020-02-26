//
//  SignupViewController.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/8/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift
import UIKit

class SignupViewController: BaseViewController {
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subTitleLabel: UILabel!
    
    @IBOutlet weak private var nameTextField: UITextField!
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var dateOfBirthTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var reEnterPasswordTextfield: UITextField!
    
    @IBOutlet weak private var nameErrorLabel: UILabel!
    @IBOutlet weak private var emailErrorLabel: UILabel!
    @IBOutlet weak private var passwordErrorLabel: UILabel!
    @IBOutlet weak private var reEnterPasswordErrorLabel: UILabel!
    @IBOutlet weak private var acceptTermsErrorLabel: UILabel!
    
    @IBOutlet weak private var loginTitleTempLabel: UILabel!
    
    @IBOutlet weak private var signupButton: UIButton!
    @IBOutlet weak private var signupWithFacebookButton: UIButton!
    @IBOutlet weak private var loginButton: UIButton!
    
    @IBOutlet weak private var closeButton: UIButton!
    
    @IBOutlet weak private var acceptTermsAndPrivacyPolicyButton: UIButton!
    @IBOutlet weak private var getPromotionButton: UIButton!
    
    @IBOutlet weak private var maleButton: UIButton!
    @IBOutlet weak private var femaleButton: UIButton!
    
    @IBOutlet weak private var showPasswordButton: UIButton!
    @IBOutlet weak private var showReEnterPasswordButton: UIButton!
    
    @IBOutlet weak private var maleLabel: UILabel!
    @IBOutlet weak private var femaleLabel: UILabel!
    @IBOutlet weak private var maleContainView: UIView!
    @IBOutlet weak private var femaleContainView: UIView!
    @IBOutlet weak private var maleImageView: UIImageView!
    @IBOutlet weak private var femaleImageView: UIImageView!
    @IBOutlet weak private var termsAndConditionLabel: UILabel!
    
    @IBOutlet weak private var maleLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak private var maleLabelLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak private var femaleLabelLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak private var femaleLabelWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak private var passwordValidatedImageView: UIImageView!
    @IBOutlet weak private var reEnterPasswordValidatedImageView: UIImageView!
    
    var onOpenEmailVerifyVC = PublishSubject<EmailVerificationViewModel>()
    
    private var datePicker: UIDatePicker!
    
    private let viewModel = SignupViewModel(interactor: Components.signupInteractor(),
                                            facebookConnectionService: Components.facebookConnectionService)
    private let defaultImageWidth: CGFloat = 30.0
    private let passwordTextFieldLeftInset: CGFloat = 32.0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindData()
        bindEvents()
    }
    
    // MARK: Private functions
    
    private func setupUI() {
        titleLabel.text = R.string.localizable.signupTitle()
        subTitleLabel.text = R.string.localizable.signupSubTitle()
       
        nameTextField.delegate = self
        emailTextField.delegate = self
        dateOfBirthTextField.delegate = self
        passwordTextField.delegate = self
        reEnterPasswordTextfield.delegate = self
        
        nameTextField.textAlignment = Constants.DefaultValue.shouldRightToLeft ? .right : .left
        emailTextField.textAlignment = Constants.DefaultValue.shouldRightToLeft ? .right : .left
        dateOfBirthTextField.textAlignment = Constants.DefaultValue.shouldRightToLeft ? .right : .left
        passwordTextField.textAlignment = Constants.DefaultValue.shouldRightToLeft ? .right : .left
        reEnterPasswordTextfield.textAlignment = Constants.DefaultValue.shouldRightToLeft ? .right : .left
        
        nameTextField.placeholder = R.string.localizable.signupEnterFullnamePlaceHolder()
        emailTextField.placeholder = R.string.localizable.commonEmailPlaceHolder()
        dateOfBirthTextField.placeholder = R.string.localizable.signupEnterDateOfBirthPlaceHolder()
        passwordTextField.placeholder = R.string.localizable.commonPasswordPlaceHolder()
        reEnterPasswordTextfield.placeholder = R.string.localizable.signupReEnterPasswordPlaceHolder()
        
        nameTextField.font = Fonts.Primary.regular.toFontWith(size: 14)
        emailTextField.font = Fonts.Primary.regular.toFontWith(size: 14)
        dateOfBirthTextField.font = Fonts.Primary.regular.toFontWith(size: 14)
        passwordTextField.font = Fonts.Primary.regular.toFontWith(size: 14)
        reEnterPasswordTextfield.font = Fonts.Primary.regular.toFontWith(size: 14)
        
        dateOfBirthTextField.setRightPaddingPoints(passwordTextField.frame.size.height)
        passwordTextField.setRightPaddingPoints(passwordTextField.frame.size.height)
        reEnterPasswordTextfield.setRightPaddingPoints(passwordTextField.frame.size.height)
        
        loginTitleTempLabel.isHidden = true
        
        signupButton.setTitle(R.string.localizable.signupSignupButtonTitle(), for: .normal)
        signupWithFacebookButton.setTitle(R.string.localizable.signupSignupWithFacebookButtonTitle(), for: .normal)
        loginButton.setTitle(R.string.localizable.signupBackToLogin(), for: .normal)
        
        let radius = 5.0 as CGFloat
        
        nameTextField.format(cornerRadius: radius, color: Colors.unselectedTabbarItem.color())
        emailTextField.format(cornerRadius: radius, color: Colors.unselectedTabbarItem.color())
        dateOfBirthTextField.format(cornerRadius: radius, color: Colors.unselectedTabbarItem.color())
        passwordTextField.format(cornerRadius: radius, color: Colors.unselectedTabbarItem.color())
        reEnterPasswordTextfield.format(cornerRadius: radius, color: Colors.unselectedTabbarItem.color())
        
        setupConstraintsForButton(label: maleLabel, leftConstraint: maleLabelLeftConstraint,
                                  widthConstraint: maleLabelWidthConstraint,
                                  buttonHeight: maleLabel.frame.size.height, imageWidth: defaultImageWidth,
                                  superViewWidth: maleLabel.superview!.frame.size.width)
        setupConstraintsForButton(label: femaleLabel, leftConstraint: femaleLabelLeftConstraint,
                                  widthConstraint: femaleLabelWidthConstraint,
                                  buttonHeight: femaleLabel.frame.size.height, imageWidth: defaultImageWidth,
                                  superViewWidth: femaleLabel.superview!.frame.size.width)
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.timeZone = NSTimeZone.local
        datePicker.maximumDate = Date()
        datePicker.locale = NSLocale.current
        datePicker.date = Constants.DefaultValue.defaultDateOfBirth
        dateOfBirthTextField.inputView = datePicker
        
        termsAndConditionLabel.attributedText = formatTextForTermAndCondition()
        
        self.setErrorTextAndErrorStatus(errorLabel: self.nameErrorLabel, textField: self.nameTextField, text: "")
        self.setErrorTextAndErrorStatus(errorLabel: self.emailErrorLabel, textField: self.emailTextField, text: "")
        self.setErrorTextAndErrorStatus(errorLabel: self.passwordErrorLabel,
                                        textField: self.passwordTextField, text: "")
        self.setErrorTextAndErrorStatus(errorLabel: self.reEnterPasswordErrorLabel,
                                        textField: self.reEnterPasswordTextfield, text: "")
        acceptTermsErrorLabel.text = ""
        self.dateOfBirthTextField.text = viewModel.dateOfBirth.value
    }
    
    // swiftlint:disable:next function_parameter_count
    private func setupConstraintsForButton(label: UILabel, leftConstraint: NSLayoutConstraint,
                                   widthConstraint: NSLayoutConstraint, buttonHeight: CGFloat, imageWidth: CGFloat,
                                   superViewWidth: CGFloat) {
        widthConstraint.constant = label.text!.width(withConstrainedHeight: buttonHeight, font: label.font)
        leftConstraint.constant = (superViewWidth - (widthConstraint.constant + imageWidth)) / 2
    }
    
    private func formatTextForTermAndCondition() -> NSAttributedString {
        let text = R.string.localizable.signupAcceptTermsAndPrivacy()
        let attributedString = NSMutableAttributedString(string: text)
        
        if let range = text.range(of: R.string.localizable.signupUse()) {
            let nsRange = text.nsRange(from: range)
            attributedString.addAttribute(NSAttributedStringKey.font,
                                          value: Fonts.Primary.semiBold.toFontWith(size: 12)!, range: nsRange)
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor,
                                          value: Colors.dark.color(), range: nsRange)
        }
        if let range = text.range(of: R.string.localizable.signupPrivacyPolicy()) {
            let nsRange = text.nsRange(from: range)
            attributedString.addAttribute(NSAttributedStringKey.font,
                                          value: Fonts.Primary.semiBold.toFontWith(size: 12)!, range: nsRange)
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor,
                                          value: Colors.dark.color(), range: nsRange)
        }
        return attributedString
    }
    
    private func bindData() {
        bindGender()
        acceptTermsAndPrivacyPolicyButton.isSelected = viewModel.isPrivacyAccepted.value
        disposeBag.addDisposables([
            nameTextField.rx.text.orEmpty.bind(to: viewModel.name),
            emailTextField.rx.text.orEmpty.bind(to: viewModel.email),
            passwordTextField.rx.text.orEmpty.bind(to: viewModel.password),
            nameTextField.rx.text.orEmpty.bind(to: viewModel.name),
            dateOfBirthTextField.rx.text.orEmpty.bind(to: viewModel.dateOfBirth),
            reEnterPasswordTextfield.rx.text.orEmpty.bind(to: viewModel.reEnterPassword)
        ])
    }
    
    private func fillFacebookProfile(facebookProfile: FacebookProfile) {
        nameTextField.text = facebookProfile.name ?? ""
        viewModel.name.value = facebookProfile.name ?? ""
        emailTextField.text = facebookProfile.email ?? ""
        viewModel.email.value = facebookProfile.email ?? ""
        
        if let birthday = facebookProfile.birthday {
            dateOfBirthTextField.text = birthday.toDateString(format: Constants.DateFormater.BirthDay)
            viewModel.dateOfBirth.value = self.dateOfBirthTextField.text!
        }
        if let genderStr = facebookProfile.gender, let gender = Gender(rawValue: genderStr) {
            viewModel.gender.value = gender
            bindGender()
        }
        
        self.setErrorTextAndErrorStatus(errorLabel: self.nameErrorLabel, textField: self.nameTextField, text: "")
        self.setErrorTextAndErrorStatus(errorLabel: self.emailErrorLabel, textField: self.emailTextField, text: "")
    }
    
    private func bindGender() {
        if viewModel.gender.value == .male {
            maleContainView.backgroundColor = UIColor.white
            maleImageView.image = R.image.iconSelected()
            femaleContainView.backgroundColor = Colors.defaultBg.color()
            femaleImageView.image = R.image.iconUnselected()
        } else {
            maleContainView.backgroundColor = Colors.defaultBg.color()
            maleImageView.image = R.image.iconUnselected()
            femaleContainView.backgroundColor = UIColor.white
            femaleImageView.image = R.image.iconSelected()
        }
    }
    
    // MARK: - Events
    
    private func bindEvents() {
        let viewTapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(viewTapGesture)
        
        disposeBag.addDisposables([
            closeButton.rx.tap.subscribe(onNext: { [unowned self] _ in
                self.dismiss(animated: true, completion: nil)
            }),
            
            loginButton.rx.tap.subscribe(onNext: { [unowned self] _ in
                self.dismiss(animated: true, completion: nil)
            }),

            maleButton.rx.tap.subscribe(onNext: { [unowned self] _ in
                self.viewModel.gender.value = .male
                self.bindGender()
            }),
            
            femaleButton.rx.tap.subscribe(onNext: { [unowned self] _ in
                self.viewModel.gender.value = .female
                self.bindGender()
            }),
            
            datePicker.rx.controlEvent(.valueChanged).subscribe(onNext: { [unowned self] _ in
                self.dateOfBirthTextField.text =
                    self.datePicker.date.toDateString(format: Constants.DateFormater.BirthDay)
                self.viewModel.dateOfBirth.value = self.dateOfBirthTextField.text!
            }),
            
            acceptTermsAndPrivacyPolicyButton.rx.tap.subscribe(onNext: { [unowned self] _ in
                self.acceptTermsAndPrivacyPolicyButton.isSelected = !self.acceptTermsAndPrivacyPolicyButton.isSelected
                self.viewModel.isPrivacyAccepted.value = self.acceptTermsAndPrivacyPolicyButton.isSelected
            }),
            
            getPromotionButton.rx.tap.subscribe(onNext: { [unowned self] _ in
                self.getPromotionButton.isSelected = !self.getPromotionButton.isSelected
                self.viewModel.subcribe.value = self.getPromotionButton.isSelected
            }),
            
            viewTapGesture.rx.event.bind(onNext: { [unowned self] _ in
                self.view.endEditing(true)
            }),
            
            signupButton.rx.tap.debounce(1.0, scheduler: MainScheduler.instance)
                .subscribe(onNext: { [unowned self] _ in
                    self.view.endEditing(true)
                    self.viewModel.signUp()
            }),
            
            signupWithFacebookButton.rx.tap.subscribe(onNext: { [unowned self] _ in
                self.viewModel.loginFacebook(viewController: self)
            }),
            
            viewModel.onWillStartSignup.subscribe(onNext: { [unowned self] _ in
                self.showLoading(status: "", showInView: nil)
            }),
            
            viewModel.onWillStopSignup.subscribe(onNext: {
                self.hideLoading(showInView: nil)
            }),
            
            viewModel.onEmailRequired.subscribe(onNext: { [unowned self] _ in
                self.setErrorTextAndErrorStatus(errorLabel: self.emailErrorLabel,
                                                textField: self.emailTextField,
                                                text: R.string.localizable.errorFieldIsRequired())
            }),
            
            viewModel.onInvalidEmail.subscribe(onNext: { [unowned self] _ in
                self.setErrorTextAndErrorStatus(errorLabel: self.emailErrorLabel,
                                                textField: self.emailTextField,
                                                text: R.string.localizable.errorEmailFormatIncorrect())
            }),
            
            viewModel.onPasswordRequired.subscribe(onNext: { [unowned self] _ in
                self.setErrorTextAndErrorStatus(errorLabel: self.passwordErrorLabel,
                                                textField: self.passwordTextField,
                                                text: R.string.localizable.errorFieldIsRequired())
            }),
            
            viewModel.onInvalidPassword.subscribe(onNext: { [unowned self] value in
                self.setErrorTextAndErrorStatus(errorLabel: self.passwordErrorLabel,
                                                textField: self.passwordTextField,
                                                text: value)
            }),
            
            viewModel.onReEnterPasswordRequired.subscribe(onNext: { [unowned self] _ in
                self.setErrorTextAndErrorStatus(errorLabel: self.reEnterPasswordErrorLabel,
                                                textField: self.reEnterPasswordTextfield,
                                                text: R.string.localizable.errorFieldIsRequired())
            }),
            
            viewModel.onInvalidReEnterPassword.subscribe(onNext: { [unowned self] _ in
                self.setErrorTextAndErrorStatus(errorLabel: self.reEnterPasswordErrorLabel,
                                                textField: self.reEnterPasswordTextfield,
                                                text: R.string.localizable.errorPasswordsNotMatch())
            }),
            
            viewModel.onPrivacyAcceptedRequired.subscribe(onNext: { [unowned self] _ in
                self.acceptTermsErrorLabel.text = R.string.localizable.errorAcceptTermsRequired()
            }),
            
            viewModel.onEmailValidated.subscribe(onNext: { [unowned self] _ in
                self.setErrorTextAndErrorStatus(errorLabel: self.emailErrorLabel,
                                                textField: self.emailTextField, text: "")
            }),
            
            viewModel.onPasswordValidated.subscribe(onNext: { [unowned self] _ in
                self.setErrorTextAndErrorStatus(errorLabel: self.passwordErrorLabel,
                                                textField: self.passwordTextField, text: "")
            }),
            
            viewModel.onReEnterPasswordValidated.subscribe(onNext: { [unowned self] _ in
                self.setErrorTextAndErrorStatus(errorLabel: self.reEnterPasswordErrorLabel,
                                                textField: self.reEnterPasswordTextfield, text: "")
            }),
            
            viewModel.onPrivacyAcceptedValidated.subscribe(onNext: { [unowned self] _ in
                self.acceptTermsErrorLabel.text = ""
            }),
            
            viewModel.onShowError.subscribe(onNext: { [unowned self] error in
                if error == GigyaCodeEnum.accountPendingVerification {
                    self.dismiss(animated: false, completion: {
                        let model = EmailVerificationViewModel(interactor: Components.emailVerificationInteractor(),
                                                               email: self.viewModel.email.value)
                        self.onOpenEmailVerifyVC.onNext((model))
                    })
                } else {
                    if let text = error.errorString(), !text.isEmpty {
                        self.showMessage(message: text)
                    }
                }
            }),
            
            viewModel.onGetFacebookProfile.subscribe(onNext: { [unowned self] facebookProfile in
                self.fillFacebookProfile(facebookProfile: facebookProfile)
            }),
            
            viewModel.onEnableSignupButton
                .bind(onNext: { [unowned self] isEnable in
                    self.signupButton.backgroundColor = isEnable ? Colors.enabledButtonGrayColor.color() :
                        Colors.disabledButtonGrayColor.color()
                }),
            
            viewModel.onShowPasswordValidated
                .bind(onNext: { [unowned self] isValidated in
                    if isValidated {
                        self.passwordValidatedImageView.isHidden = false
                        self.passwordTextField.setLeftPaddingPoints(self.passwordTextFieldLeftInset)
                    } else {
                        self.passwordValidatedImageView.isHidden = true
                        self.passwordTextField.setLeftPaddingPoints(0)
                    }
                }),
            
            viewModel.onShowReEnterPasswordValidated
                .bind(onNext: { [unowned self] isValidated in
                    if isValidated {
                        self.reEnterPasswordValidatedImageView.isHidden = false
                    self.reEnterPasswordTextfield.setLeftPaddingPoints(self.passwordTextFieldLeftInset)
                    } else {
                        self.reEnterPasswordValidatedImageView.isHidden = true
                        self.reEnterPasswordTextfield.setLeftPaddingPoints(0)
                    }
                }),
            
            showPasswordButton.rx.tap.subscribe(onNext: { [unowned self] _ in
                self.passwordTextField.isSecureTextEntry = !self.passwordTextField.isSecureTextEntry
            }),
            
            showReEnterPasswordButton.rx.tap.subscribe(onNext: { [unowned self] _ in
                self.reEnterPasswordTextfield.isSecureTextEntry = !self.reEnterPasswordTextfield.isSecureTextEntry
            })
        ])
    }
}

// MARK: - UITextFieldDelegate

extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            dateOfBirthTextField.becomeFirstResponder()
        } else if textField == dateOfBirthTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == dateOfBirthTextField {
            view.endEditing(true)
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.isEqual(emailTextField) {
            self.setErrorTextAndErrorStatus(errorLabel: self.emailErrorLabel, textField: self.emailTextField,
                                            text: "")
        } else if textField.isEqual(passwordTextField) {
            self.setErrorTextAndErrorStatus(errorLabel: self.passwordErrorLabel, textField: self.passwordTextField,
                                            text: "")
        } else if textField.isEqual(reEnterPasswordTextfield) {
            self.setErrorTextAndErrorStatus(errorLabel: self.reEnterPasswordErrorLabel,
                                            textField: self.reEnterPasswordTextfield, text: "")
        }
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField != dateOfBirthTextField
    }
}
