//
//  DropdownFormCell.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 3/29/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class DropdownFormCell: BaseTableViewCell {
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var textField: UITextField!
    @IBOutlet weak private var dropDownButton: UIButton!
    
    var pickerView: UIPickerView!
    
    private var strText: String = ""
    private var strValue: String = ""
    
    var arrayData = [DropdownListFormItem]()
    
    var onDidSubmitRequest = PublishSubject<(text: String, value: String)>()
    
    var item: FormItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        textField.textAlignment = Constants.DefaultValue.shouldRightToLeft ? .right : .left
        textField.font = Fonts.Primary.regular.toFontWith(size: 12)
    }
    
    func bindData(item: FormItem, arrayData: [DropdownListFormItem]) {
        self.item = item
    
        titleLabel.text = item.titleLabel
        textField.placeholder = item.placeHolder
        textField.delegate = self
        
        pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        textField.inputView = pickerView
        
        self.arrayData = arrayData
        pickerView.reloadAllComponents()
        
        bindEvents()
        
        if !self.arrayData.isEmpty, let index = arrayData.index(where: { item.valueText == $0.value }) {
            pickerView.selectRow(index, inComponent: 0, animated: false)
            let objTemp = arrayData[index]
            self.updateValue(strText: objTemp.titleLabel, strValue: objTemp.value)
        }
    }
    
    // MARK: - Events
    
    private func bindEvents() {
        disposeBag.addDisposables([
            dropDownButton.rx.tap.subscribe(onNext: { _ in
                self.textField.becomeFirstResponder()
            })
        ])
    }
    
    // MARK: - Private methods
    
    private func updateValue(strText: String, strValue: String) {
        self.textField.text = strText
        self.strText = strText
        self.strValue = strValue
        item?.valueText = strValue
        onDidSubmitRequest.onNext((strText, strValue))
    }
}

// MARK: - UITextFieldDelegate

extension DropdownFormCell: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension DropdownFormCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let objTemp = arrayData[row]
        return objTemp.titleLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let objTemp = arrayData[row]
        self.updateValue(strText: objTemp.titleLabel, strValue: objTemp.value)
    }
}
