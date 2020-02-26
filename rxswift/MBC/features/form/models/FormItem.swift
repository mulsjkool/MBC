//
//  FormItem.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 3/29/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class FormItem {
    let titleLabel: String
    let placeHolder: String
    let type: FormItemEnum
    
    var valueText: String
    var error: String
    
    init(titleLabel: String, placeHolder: String, type: FormItemEnum, defaultValue: String) {
        self.titleLabel = titleLabel
        self.placeHolder = placeHolder
        self.type = type
        self.error = ""
        self.valueText = defaultValue
    }
}

class DropdownListFormItem {
    let titleLabel: String
    let value: String
    
    init(titleLabel: String, value: String) {
        self.titleLabel = titleLabel
        self.value = value
    }
}

class RadioGroupFormItem {
    let title: String
    
    let titleLeft: String
    let valueLeft: String
    
    let titleRight: String
    let valueRight: String
    
    let type: FormItemEnum
    
    var valueText: String
    var error: String
    
    init(title: String, titleLeft: String, valueLeft: String, titleRight: String, valueRight: String,
         type: FormItemEnum) {
        self.title = title
        
        self.titleLeft = titleLeft
        self.valueLeft = valueLeft
        
        self.titleRight = titleRight
        self.valueRight = titleRight
        
        self.error = ""
        self.valueText = ""
        self.type = type
    }
}
