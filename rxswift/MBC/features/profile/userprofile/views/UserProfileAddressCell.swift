//
//  UserProfileAddressCell.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 1/26/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class UserProfileAddressCell: BaseTableViewCell {
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var valueLabel: UILabel!
    
    @IBOutlet weak private var errorAddressLabel: UILabel!
    
    @IBOutlet weak private var addressTextField: UITextField!
    @IBOutlet weak private var cityTextField: UITextField!
    @IBOutlet weak private var countryTextField: UITextField!
    
    @IBOutlet weak private var okButton: UIButton!
    @IBOutlet weak private var cancelButton: UIButton!
    @IBOutlet weak private var editButton: UIButton!
    
    @IBOutlet weak private var arrowCityButton: UIButton!
    @IBOutlet weak private var arrowCountryButton: UIButton!
    
    @IBOutlet private var constraintBottomTF: NSLayoutConstraint!
    
    private var isNeedUpdateCountryData: Bool = true
    private var isNeedUpdateCityData: Bool = true
    private var isNeedUpdateAddressData: Bool = true
    
    private var strAddressText: String = ""
    private var strCityText: String = ""
    private var strCityValue: String = ""
    private var strCountryText: String = ""
    private var strCountryValue: String = ""
    
    private var errorAddressText: String = ""
    
    var cityPickerView: UIPickerView = UIPickerView()
    var countryPickerView: UIPickerView = UIPickerView()
    
    var arrayCityData = [ProfileListBoxItem]()
    var arrayCountryData = [ProfileListBoxItem]()
    
    var profileItem: ProfileAddressItem!
    
    var onDidSubmitRequest = PublishSubject< (strAddress: String, cityCode: String, cityName: String,
        countryCode: String, countryName: String) >()
    var onNeedReloadCell = PublishSubject<Void>()
    var onEditButtonClicked = PublishSubject<Void>()
    var onDidSelectCoutry = PublishSubject<(cell: UserProfileAddressCell, countryCode: String)>()
    var onShouldBeginSelectingCity = PublishSubject<(cell: UserProfileAddressCell, countryCode: String)>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupUI()
    }

    private func setupUI() {
        addressTextField.delegate = self
        cityTextField.delegate = self
        countryTextField.delegate = self
        
        addressTextField.textAlignment = Constants.DefaultValue.shouldRightToLeft ? .right : .left
        cityTextField.textAlignment = Constants.DefaultValue.shouldRightToLeft ? .right : .left
        countryTextField.textAlignment = Constants.DefaultValue.shouldRightToLeft ? .right : .left
        
        addressTextField.font = Fonts.Primary.regular.toFontWith(size: 12)
        cityTextField.font = Fonts.Primary.regular.toFontWith(size: 12)
        countryTextField.font = Fonts.Primary.regular.toFontWith(size: 12)
        
        cityTextField.setRightPaddingPoints(cityTextField.frame.size.height)
        countryTextField.setRightPaddingPoints(countryTextField.frame.size.height)
        
        cityPickerView.dataSource = self
        cityPickerView.delegate = self
        cityTextField.inputView = cityPickerView
        
        countryPickerView.dataSource = self
        countryPickerView.delegate = self
        countryTextField.inputView = countryPickerView
        
        self.updateErrorLabel(errorText: errorAddressText)
    }
    
    func bindData(item: ProfileAddressItem, user: UserProfile?, arrayCountry: [ProfileListBoxItem],
                  arrayCity: [ProfileListBoxItem]) {
        self.profileItem = item
        
        self.isEditingView(flag: item.isEditting)
        
        titleLabel.text = item.titleLabel
        addressTextField.placeholder = item.placeHolderAddress
        cityTextField.placeholder = item.placeHolderCity
        countryTextField.placeholder = item.placeHolderCountry
        
        self.arrayCountryData = arrayCountry
        self.arrayCityData = arrayCity
        
        cityPickerView.reloadAllComponents()
        countryPickerView.reloadAllComponents()
        
        self.updateDataForView(user: user)
        self.bindEvents()
    }
    
    // MARK: - Private methods
    
    private func updateDataForView(user: UserProfile?) {
        guard let user = user else { return }
        
        if isNeedUpdateAddressData {
            strAddressText = user.address
            addressTextField.text = strAddressText
        }
        
        ///////////////////////////////
        if isNeedUpdateCityData {
            strCityValue = user.city
            
            if strCityValue.isEmpty && !self.arrayCityData.isEmpty {
                let obj = self.arrayCityData[0]
                strCityValue = obj.value
            }
            
            let stringTemp = self.checkStringInArray(array: self.arrayCityData, code: strCityValue)
            strCityText = stringTemp.isEmpty ? strCityValue : stringTemp
            cityPickerView.selectRow(self.checkIndexInArray(array: self.arrayCityData,
                                                            code: strCityValue), inComponent: 0, animated: false)
            cityTextField.text = strCityText
        }
        
        ///////////////////////////////
        if isNeedUpdateCountryData {
            strCountryValue = user.country
            strCountryText = self.checkStringInArray(array: self.arrayCountryData, code: strCountryValue)
            countryPickerView.selectRow(self.checkIndexInArray(array: self.arrayCountryData,
                                                               code: strCountryValue), inComponent: 0, animated: false)
            countryTextField.text = strCountryText
        }
        
        ///////////////////////////////
        updateValueText()
    }
    
    private func checkIndexInArray(array: [ProfileListBoxItem], code: String) -> Int {
        var index: Int = 0
        
        if array.isEmpty { return index }
        
        for item in array {
            let obj = item
            if code == obj.value { return index }
            index += 1
        }
        
        if index >= array.count { index = 0 }
        
        return index
    }
    
    private func checkStringInArray(array: [ProfileListBoxItem], code: String) -> String {
        if array.isEmpty { return "" }
        for item in array {
            let obj = item
            if code == obj.value {
                let text = obj.titleLabel.isEmpty ? obj.titleENLabel : obj.titleLabel
                return text
            }
        }
        return ""
    }
    
    private func isEditingView(flag: Bool) {
        okButton.isHidden = !flag
        cancelButton.isHidden = !flag
        editButton.isHidden = flag
        addressTextField.isHidden = !flag
        cityTextField.isHidden = !flag
        countryTextField.isHidden = !flag
        arrowCityButton.isHidden = !flag
        arrowCountryButton.isHidden = !flag
        
        valueLabel.isHidden = flag
        
        constraintBottomTF.isActive = !flag
    }
    
    private func updateStatus() {
        self.profileItem.isEditting = !self.profileItem.isEditting
        self.isEditingView(flag: self.profileItem.isEditting)
    }
    
    private func updateValue(pickerView: UIPickerView, strText: String, strValue: String) {
        if pickerView == cityPickerView {
            cityTextField.text = strText
            strCityText = strText
            strCityValue = strValue
        } else {
            countryTextField.text = strText
            strCountryText = strText
            strCountryValue = strValue
            isNeedUpdateCountryData = false
            isNeedUpdateCityData = true
            isNeedUpdateAddressData = false
            self.onDidSelectCoutry.onNext((self, strCountryValue))
        }
    }
    
    private func updateValueText() {
        var array = [String]()
        
        if !strAddressText.isEmpty { array.append(strAddressText) }
        if !strCityText.isEmpty { array.append(strCityText) }
        if !strCountryText.isEmpty { array.append(strCountryText) }
        
        var stringTmp = ""
        if !array.isEmpty {
            stringTmp = array.joined(separator: Constants.DefaultValue.UserProfileAddressSeparatorString)
        }
        valueLabel.text = stringTmp
    }
    
    private func checkFieldRequired() -> Bool {
        if self.strAddressText.isEmpty {
            self.updateErrorLabel(errorText: R.string.localizable.errorFieldIsRequired())
            self.onNeedReloadCell.onNext(())
            return false
        }
        return true
    }
    
    private func updateErrorLabel(errorText: String) {
        errorAddressText = errorText
        self.setErrorTextAndErrorStatus(errorLabel: errorAddressLabel, textField: addressTextField,
                                        text: errorText)
    }
    
    private func hideKeyboard() {
        addressTextField.resignFirstResponder()
        cityTextField.resignFirstResponder()
        countryTextField.resignFirstResponder()
    }
    
    // MARK: - Events
    
    private func bindEvents() {
        disposeBag.addDisposables([
            arrowCityButton.rx.tap.subscribe(onNext: { _ in
                self.cityTextField.becomeFirstResponder()
            }),
            
            arrowCountryButton.rx.tap.subscribe(onNext: { _ in
                self.countryTextField.becomeFirstResponder()
            })
        ])
    }
    
    // MARK: - Action
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.hideKeyboard()
        self.updateStatus()
        self.updateErrorLabel(errorText: "")
        isNeedUpdateCityData = false
        isNeedUpdateCountryData = false
        isNeedUpdateAddressData = false
        self.onNeedReloadCell.onNext(())
    }
    
    @IBAction func okButtonClicked(_ sender: Any) {
        self.hideKeyboard()
        
        if self.checkFieldRequired() {
            self.updateStatus()
            isNeedUpdateCityData = true
            isNeedUpdateCountryData = true
            isNeedUpdateAddressData = true
            onDidSubmitRequest.onNext((strAddress: strAddressText, cityCode: strCityValue, cityName: strCityText,
                                       countryCode: strCountryValue, countryName: strCountryText))
        }
    }
    
    @IBAction func editButtonClicked(_ sender: Any) {
        self.hideKeyboard()
        self.updateStatus()
        isNeedUpdateCityData = true
        isNeedUpdateCountryData = true
        isNeedUpdateAddressData = true
        onEditButtonClicked.onNext(())
    }
}

// MARK: - UITextFieldDelegate

extension UserProfileAddressCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if !self.strCountryValue.isEmpty && textField == cityTextField {
            self.onShouldBeginSelectingCity.onNext((cell: self, countryCode: self.strCountryValue))
        } else if textField.isEqual(addressTextField) && !errorAddressText.isEmpty {
            self.updateErrorLabel(errorText: "")
            self.onNeedReloadCell.onNext(())
        }
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let strText = textFieldText.replacingCharacters(in: range, with: string)
        
        if textField == addressTextField {
            strAddressText = strText
        } else if textField == cityTextField || textField == countryTextField {
            return false
        }
        
        return true
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension UserProfileAddressCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == cityPickerView {
            return arrayCityData.count
        } else {
            return arrayCountryData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var obj: ProfileListBoxItem?
        if pickerView == cityPickerView {
            let objTemp = arrayCityData[row]
            obj = objTemp
        } else {
            let objTemp = arrayCountryData[row]
            obj = objTemp
        }
        
        return obj?.titleENLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var obj: ProfileListBoxItem
        if pickerView == cityPickerView {
            if arrayCityData.isEmpty { return }
            let objTemp = arrayCityData[row]
            obj = objTemp
        } else {
            if arrayCountryData.isEmpty { return }
            let objTemp = arrayCountryData[row]
            obj = objTemp
        }
        
        self.updateValue(pickerView: pickerView, strText: obj.titleENLabel, strValue: obj.value)
    }
}
