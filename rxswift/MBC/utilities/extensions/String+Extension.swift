//
//  String+Extension.swift
//  MBC
//
//  Created by Huy Kieu Anh on 6/22/16.
//  Copyright © 2016 MBC. All rights reserved.
//

import Foundation
import UIKit

extension String {

    // swiftlint:disable:next variable_name
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }

    // swiftlint:disable:next variable_name
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }

    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: range.lowerBound)
        let idx2 = index(startIndex, offsetBy: range.upperBound)
        return String(self[idx1..<idx2])
    }
    
    var length: Int {
        return self.count
    }

    var isEmail: Bool {
        let emailRegExpression = "\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}\\b"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegExpression)
        return emailPredicate.evaluate(with: self)
    }

    var isPassword: Bool {
        let regExpression = "(?!^[0-9]*$)(?!^[a-zA-Z]*$)^([a-zA-Z0-9]{8,999})$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regExpression)
        return predicate.evaluate(with: self)
    }
    
    var isPhoneNumber: Bool {
        let regExpression = "^[+]?[0-9.*#,;\\(\\) ]{0,20}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regExpression)
        return predicate.evaluate(with: self)
    }
    
    func canOpenURL() -> Bool {
        guard let url = URL(string: self) else { return false }
        if !UIApplication.shared.canOpenURL(url) { return false }

        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [regEx])
        return predicate.evaluate(with: self)
    }

    func trimAllSpace() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }

    func bundleImage() -> UIImage? {
        return UIImage(named: self)
    }

    var URLStringByDeletingLastComponent: String {
        return (self as NSString).deletingLastPathComponent.replacingOccurrences(of: "http:/", with: "http://")
    }

    func URLStringByAppendingString(extra: String) -> String {
        guard extra.length > 0 else { return self }

        guard extra[0] == "/" else {
            return self.URLStringByDeletingLastComponent + "/" + extra
        }

        return self + extra
    }

    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range) }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }

    func rangesOf(searchString: String) -> [NSRange] {
        var ranges = [NSRange]()
        do {
            // Create the regular expression.
            let regex = try NSRegularExpression(pattern: searchString, options: [])

            // Use the regular expression to get an array of NSTextCheckingResult.
            // Use map to extract the range from each result.
            ranges = regex.matches(in: self,
                                   options: [],
                                   range: NSRange(location: 0, length: self.count)).map { $0.range }
        } catch {
            // There was a problem creating the regular expression
            ranges = []
        }
        return ranges
    }

    func firstMatch(for regex: String) -> String? {
        return matches(for: regex).first
    }

    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func localized() -> String {
        let language = Components.languageRepository.currentLanguage() ?? "en"
        if let path = Bundle.main.path(forResource: language, ofType: "lproj"),
            let bundle = Bundle(path: path) {
            let string = bundle.localizedString(forKey: self, value: "", table: nil)

            if string == self {
                return bundle.localizedString(forKey: self, value: "", table: "Phase2")
            }

            return string
        }
        return self
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedStringKey.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedStringKey.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    
    func htmlToAttributedString() -> NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8),
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    func getCountryName() -> String? {
        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: self) {
            return name
        } else {
            return self
        }
    }
    
    func getLanguageName() -> String? {
        if let name = (Locale.current as NSLocale).displayName(forKey: .languageCode, value: self) {
            return name
        } else {
            return self
        }
    }
    
    func getLocalizedString(languageConfigList: [LanguageConfigListEntity], type: String) -> String? {
        guard let dataType = Constants.localizationMappingDict[type] else {
            return nil
        }
        
        for list in languageConfigList where dataType == list.type {
            for configurationData in list.dataList where self.lowercased() == configurationData.code.lowercased() {
                let currentLanguage = Components.languageRepository.currentLanguageEnum()?.rawValue
                for name in configurationData.names where currentLanguage?.lowercased() == name.locate.lowercased() {
                    return name.text
                }
                for name in configurationData.names where name.locate.lowercased()
                    == LanguageEnum.english.rawValue.lowercased() {
                    return name.text
                }
            }
        }
        
        return nil
    }
    
    func fileExtension() -> String {
        guard let fileExtension = NSURL(fileURLWithPath: self).pathExtension else { return "" }
        
        return fileExtension
    }
    
    var isGifFileName: Bool {
        return self.lowercased().contains(".gif")
    }
    
    func nsRange(from range: Range<Index>) -> NSRange {
        return NSRange(range, in: self)
    }
    
    func verifyUrl() -> Bool {
        if let url = URL(string: self) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func percentEncoding() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
    }
    
    func indexOf(target: String) -> Int? {
        let range = (self as NSString).range(of: target)
        
        guard Range(range) != nil else {
            return nil
        }
        
        return range.location
    }
    
    func lastIndexOf(target: String) -> Int? {
        let range = (self as NSString).range(of: target, options: NSString.CompareOptions.backwards)
        
        guard Range(range) != nil else {
            return nil
        }
        
        return self.count - range.location - 1        
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
}
