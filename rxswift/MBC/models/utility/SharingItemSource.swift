//
//  SharingItemSource.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 4/3/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class SharingStringItemSource: NSObject, UIActivityItemSource {
    var strPath: String?
    var strTitle: String?
    var strDescription: String?
    
    let maxStringLenght: Int = 150
    let maxTwitterStringLenght: Int = 50
    
    init(strPath: String?, strTitle: String?, strDescription: String?) {
        self.strPath = strPath
        self.strTitle = strTitle
        self.strDescription = strDescription
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController,
                                       itemForActivityType activityType: UIActivityType?) -> Any? {
        switch activityType {
        case UIActivityType.mail?:
            if let description = SharingStringItemSource.checkDescriptionLenght(str: self.strDescription,
                                                                                maxStringLenght: maxStringLenght) {
                return R.string.localizable.commonShareTextFormat2params(description, Constants.DefaultValue.SiteName)
            }
            return Constants.DefaultValue.SiteName
        case UIActivityType.postToFacebook?:
            return nil
        case UIActivityType.postToTwitter?:
            return getSharingString(isTwitter: true)
        case UIActivityType.copyToPasteboard?:
            guard let path = strPath, !path.isEmpty else { return nil }
            let strURL = Components.instance.configurations.websiteBaseURL + path
            return strURL
        default:
            if let str = activityType?.rawValue {
                if str == Constants.ConfigurationSharingExtension.googlePlus {
                    return getSharingString(isTwitter: false)
                } else if str == Constants.ConfigurationSharingExtension.whatsApp {
                    return getSharingString(isTwitter: false)
                }
            }
        }
        return nil
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController,
                                       subjectForActivityType activityType: UIActivityType?) -> String {
        if activityType == UIActivityType.mail { return strTitle ?? "" }
        return ""
    }
    
    private func getSharingString(isTwitter: Bool) -> String {
        self.strDescription =
            SharingStringItemSource.checkDescriptionLenght(str: self.strDescription, maxStringLenght:
            isTwitter ? maxTwitterStringLenght : maxStringLenght)
        
        guard let title = strTitle, let description = self.strDescription else {
            if let title = strTitle, !title.isEmpty {
                return R.string.localizable.commonShareTextFormat2params(title, Constants.DefaultValue.SiteName)
            }
            if let description = self.strDescription, !description.isEmpty {
                return R.string.localizable.commonShareTextFormat2params(description, Constants.DefaultValue.SiteName)
            }
            return Constants.DefaultValue.SiteName
        }
        if title.isEmpty, description.isEmpty { return Constants.DefaultValue.SiteName }
        return R.string.localizable.commonShareTextFormat3params(title, description, Constants.DefaultValue.SiteName)
    }
    
    static private func checkDescriptionLenght(str: String?, maxStringLenght: Int) -> String? {
        guard var strTemp = str else { return nil }
        if strTemp.length > maxStringLenght { strTemp = strTemp[0..<maxStringLenght] + "..." }
        return strTemp
    }
}

class SharingImageItemSource: NSObject, UIActivityItemSource {
    var photo: Media?
    var video: Video?
    
    init(photo: Media?, video: Video?) {
        self.photo = photo
        self.video = video
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController,
                                itemForActivityType activityType: UIActivityType?) -> Any? {
        switch activityType {
        case UIActivityType.mail?:
            return getImage()
        case UIActivityType.postToFacebook?:
            return nil
        case UIActivityType.postToTwitter?:
            return getImage()
        default:
            if let str = activityType?.rawValue {
                if str == Constants.ConfigurationSharingExtension.googlePlus {
                    return getImage()
                } else if str == Constants.ConfigurationSharingExtension.whatsApp {
                    return getImage()
                }
            }
        }
        return nil
    }
    
    private func getImage() -> UIImage? {
        if let obj = photo, let url = URL(string: obj.originalLink),
            let data = try? Data(contentsOf: url), let img = UIImage(data: data) { return img }
        
        if let obj = video, let imgURL = obj.videoThumbnail, let url = URL(string: imgURL),
            let data = try? Data(contentsOf: url), let img = UIImage(data: data) { return img }
        
        return nil
    }
}

class SharingURLItemSource: NSObject, UIActivityItemSource {
    var shortLink: String?
    
    init(shortLink: String?) {
        self.shortLink = shortLink
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController,
                                itemForActivityType activityType: UIActivityType?) -> Any? {
        switch activityType {
        case UIActivityType.mail?:
            return shortLink
        case UIActivityType.postToFacebook?:
            guard let shortLink = self.shortLink else { return nil }
            return URL(string: shortLink)
        case UIActivityType.postToTwitter?:
            return shortLink
        default:
            if let str = activityType?.rawValue {
                if str == Constants.ConfigurationSharingExtension.googlePlus {
                    return shortLink
                } else if str == Constants.ConfigurationSharingExtension.whatsApp {
                    return shortLink
                }
            }
        }
        return nil
    }
}
