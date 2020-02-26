//
//  UserProfileCell.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 1/24/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class UserProfileCell: BaseTableViewCell {
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var valueLabel: UILabel!
    
    @IBOutlet weak private var inputTextField: UITextField!
    @IBOutlet weak private var errorInputLabel: UILabel!
    
    @IBOutlet weak private var okButton: UIButton!
    @IBOutlet weak private var cancelButton: UIButton!
    @IBOutlet weak private var editButton: UIButton!
    
    @IBOutlet weak private var calendarButton: UIButton!
    @IBOutlet weak private var arrowButton: UIButton!
    
    private var datePicker: UIDatePicker!
    var pickerView: UIPickerView!
    var profileItem: ProfileItem!
    private var strText: String = ""
    private var strValue: String = ""
    private var errorText: String = ""
    
    private var isNeedUpdateData: Bool = true
    
    var arrayData = [ProfileListBoxItem]()
    
    var onEditButtonClicked = PublishSubject<Void>()
    var onDidSubmitRequest = PublishSubject<(text: String, value: String)>()
    var onNeedReloadCell = PublishSubject<Void>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        inputTextField.delegate = self
        inputTextField.textAlignment = Constants.DefaultValue.shouldRightToLeft ? .right : .left
        inputTextField.font = Fonts.Primary.regular.toFontWith(size: 12)
        
        self.updateErrorLabel(errorText: self.errorText)
    }
    
    func bindData(item: ProfileItem, user: UserProfile?, arrayNationality: [ProfileListBoxItem]) {
        self.profileItem = item
        
        self.isEditingView(flag: item.isEditting)
        
        titleLabel.text = item.titleLabel
        inputTextField.placeholder = item.placeHolder
        
        updateLayoutForCell(arrayNationality: arrayNationality)
        if isNeedUpdateData { updateDataForView(user: user) }
    }
    
    // MARK: - Events
    
    private func bindDatePickerEvents() {
        disposeBag.addDisposables([
            datePicker.rx.controlEvent(.valueChanged).subscribe(onNext: { [unowned self] _ in
                let string = self.datePicker.date.toDateString(format: Constants.DateFormater.BirthDay)
                self.updateValue(strText: string, strValue: string)
            }),
            
            calendarButton.rx.tap.subscribe(onNext: { _ in
                self.inputTextField.becomeFirstResponder()
            })
        ])
    }
    
    private func bindEvents() {
        disposeBag.addDisposables([
            arrowButton.rx.tap.subscribe(onNext: { _ in
                self.inputTextField.becomeFirstResponder()
            })
        ])
    }
    
    // MARK: - Private methods
    
    private func updateErrorLabel(errorText: String) {
        self.errorText = errorText
        self.setErrorTextAndErrorStatus(errorLabel: self.errorInputLabel, textField: self.inputTextField,
                                        text: self.errorText)
    }
    
    private func updateValue(strText: String, strValue: String) {
        self.inputTextField.text = strText
        self.strText = strText
        self.strValue = strValue
        self.valueLabel.text = strText
    }
    
    private func updateDataForView(user: UserProfile?) {
        guard let user = user else { return }
        
        strText = ""
        strValue = ""
        
        if self.profileItem.type == .fullName {
            strText = user.name
            strValue = strText
        } else if self.profileItem.type == .email {
            strText = user.email
            strValue = strText
        } else if self.profileItem.type == .marriedStatus {
            strValue = user.marriedStatus
            strText = self.checkStringInArray(code: strValue)
            pickerView.selectRow(self.checkIndexInArray(code: strValue), inComponent: 0, animated: false)
        } else if self.profileItem.type == .phoneNumber {
            strText = user.phoneNumber
            strValue = strText
        } else if self.profileItem.type == .birthday {
            if let birthday = user.birthday {
                let strBirthday = birthday.toDateString(format: Constants.DateFormater.BirthDay)
                strText = strBirthday
                strValue = strText
                datePicker.date = Date.dateFromString(string: strBirthday,
                                                      format: Constants.DateFormater.DateMonthYear)
            } else {
                datePicker.date = Constants.DefaultValue.defaultDateOfBirth
            }
            
            if let strBirthday = user.birthday?.toDateString(format: Constants.DateFormater.BirthDay) {
                strText = strBirthday
                strValue = strText
                datePicker.date = Date.dateFromString(string: strBirthday,
                                                      format: Constants.DateFormater.DateMonthYear)
            }
        } else if self.profileItem.type == .nationality {
            strValue = user.nationality
            strText = self.checkStringInArray(code: strValue)
            pickerView.selectRow(self.checkIndexInArray(code: strValue), inComponent: 0, animated: false)
        }
        inputTextField.text = strText
        valueLabel.text = strText
    }
    
    private func checkIndexInArray(code: String) -> Int {
        var index: Int = 0
        
        for item in self.arrayData {
            let obj = item as ProfileListBoxItem
            if code == obj.value { return index }
            index += 1
        }
        
        if index >= self.arrayData.count { index = 0 }
        
        return index
    }
    
    private func checkStringInArray(code: String) -> String {
        for item in self.arrayData {
            let obj = item as ProfileListBoxItem
            if code == obj.value {
                let text = obj.titleLabel.isEmpty ? obj.titleENLabel : obj.titleLabel
                return text
            }
        }
        return ""
    }
    
    private func updateLayoutForCell(arrayNationality: [ProfileListBoxItem]) {
        guard let item = self.profileItem else { return }
        
        inputTextField.keyboardType = .default
        inputTextField.inputView = nil
        calendarButton.isHidden = true
        arrowButton.isHidden = true
        inputTextField.setRightPaddingPoints(0)
        
        if item.type == .email {
            inputTextField.keyboardType = .emailAddress
        } else if item.type == .phoneNumber {
            inputTextField.keyboardType = .numberPad
        } else if item.type == .birthday {
            datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.timeZone = NSTimeZone.local
            datePicker.maximumDate = Date()
            datePicker.locale = NSLocale.current
            datePicker.date = Constants.DefaultValue.defaultDateOfBirth
            inputTextField.inputView = datePicker
            bindDatePickerEvents()
            inputTextField.setRightPaddingPoints(inputTextField.frame.size.height)
            if item.isEditting { calendarButton.isHidden = false }
        } else if item.type == .marriedStatus || item.type == .nationality {
            inputTextField.setRightPaddingPoints(inputTextField.frame.size.height)
            if item.isEditting { arrowButton.isHidden = false }
            
            pickerView = UIPickerView()
            pickerView.dataSource = self
            pickerView.delegate = self
            inputTextField.inputView = pickerView
            bindEvents()
            
            if item.type == .marriedStatus {
                arrayData = MarriedStatusEnum.allItems
            } else if item.type == .nationality {
                arrayData = arrayNationality
                pickerView.reloadAllComponents()
            }
        }
    }
    
    private func isEditingView(flag: Bool) {
        okButton.isHidden = !flag
        cancelButton.isHidden = !flag
        editButton.isHidden = flag
        inputTextField.isHidden = !flag
        valueLabel.isHidden = flag
    }
    
    private func updateStatus() {
        self.profileItem.isEditting = !self.profileItem.isEditting
        self.isEditingView(flag: self.profileItem.isEditting)
        self.updateLayoutForCell(arrayNationality: self.arrayData)
    }
    
    private func checkEmail() -> Bool {
        if !self.checkFieldRequired() { return false }
        
        if !self.strText.isEmail {
            self.updateErrorLabel(errorText: R.string.localizable.errorEmailFormatIncorrect())
            needReloadCell()
            return false
        }
        
        return true
    }
    
    private func needReloadCell() {
        isNeedUpdateData = false
        self.onNeedReloadCell.onNext(())
    }
    
    private func checkFieldRequired() -> Bool {
        if strText.isEmpty {
            self.updateErrorLabel(errorText: R.string.localizable.errorFieldIsRequired())
            needReloadCell()
            return false
        }
        return true
    }
    
    private func didSubmitRequest(strText: String, strValue: String) {
        self.updateStatus()
        isNeedUpdateData = true
        valueLabel.text = strText
        onDidSubmitRequest.onNext((strText, strValue))
    }
    
    // MARK: - Action
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.inputTextField.resignFirstResponder()
        self.updateErrorLabel(errorText: "")
        self.updateStatus()
        needReloadCell()
    }
    
    @IBAction func okButtonClicked(_ sender: Any) {
        self.inputTextField.resignFirstResponder()
        
        switch self.profileItem.type {
        case .marriedStatus, .birthday, .nationality:
            didSubmitRequest(strText: self.strText, strValue: self.strValue)
        case .fullName, .phoneNumber:
            if self.checkFieldRequired() {
                didSubmitRequest(strText: self.strText, strValue: self.strValue)
            }
        case .email:
            if self.checkEmail() {
                didSubmitRequest(strText: self.strText, strValue: self.strValue)
            }
        default: break
        }
    }
    
    @IBAction func editButtonClicked(_ sender: Any) {
        self.updateStatus()
        isNeedUpdateData = true
        switch self.profileItem.type {
        case .fullName, .phoneNumber, .email:
            inputTextField.becomeFirstResponder()
        default: break
        }
        onEditButtonClicked.onNext(())
    }
}

// MARK: - UITextFieldDelegate

extension UserProfileCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.updateErrorLabel(errorText: "")
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        
        if self.profileItem.type == .birthday
            || self.profileItem.type == .nationality
            || self.profileItem.type == .marriedStatus {
            return false
        }
        
        if self.profileItem.type == .phoneNumber {
            let digitSet = CharacterSet.decimalDigits
            for ch in string.unicodeScalars {
                if !digitSet.contains(ch) {
                    return false
                }
            }
        }
        
        strText = textFieldText.replacingCharacters(in: range, with: string)
        strValue = strText
        return true
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension UserProfileCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var strTemp = ""
        if self.profileItem.type == .marriedStatus {
            let objTemp = arrayData[row]
            strTemp = objTemp.titleLabel
        } else if self.profileItem.type == .nationality {
            let objTemp = arrayData[row]
            strTemp = objTemp.titleENLabel
        }
        return strTemp
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if arrayData.isEmpty { return }
        if self.profileItem.type == .marriedStatus {
            let objTemp = arrayData[row]
            self.updateValue(strText: objTemp.titleLabel, strValue: objTemp.value)
        } else if self.profileItem.type == .nationality {
            let objTemp = arrayData[row]
            self.updateValue(strText: objTemp.titleENLabel, strValue: objTemp.value)
        }
    }
}
