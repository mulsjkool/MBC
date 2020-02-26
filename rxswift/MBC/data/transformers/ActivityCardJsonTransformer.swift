//
//  ActivityCardJsonTransformer.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/21/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import SwiftyJSON

// swiftlint:disable identifier_name
class ActivityCardJsonTransformer: JsonTransformer {
    
    let authorJsonTransformer: AuthorJsonTransformer
    let activityCardMessagePackageJsonTransformer: ActivityCardMessagePackageJsonTransformer
    
    private static let fields = (
        activityCardMessagePackage: "activityCardMessagePackage",
        authorPage: "authorPage",
        taggedPageList: "taggedPageList",
        firstTimePublish: "firstTimePublish"
    )
    
    init(authorJsonTransformer: AuthorJsonTransformer,
         activityCardMessagePackageJsonTransformer: ActivityCardMessagePackageJsonTransformer) {
        self.authorJsonTransformer = authorJsonTransformer
        self.activityCardMessagePackageJsonTransformer = activityCardMessagePackageJsonTransformer
    }
    
    func transform(json: JSON) -> ActivityCardEntity {
        let fields = ActivityCardJsonTransformer.fields
        
        let activityCardMessagePackage = (json[fields.activityCardMessagePackage] != JSON.null)
            ? activityCardMessagePackageJsonTransformer.transform(json: json[fields.activityCardMessagePackage]) : nil
        let authorPage = (json[fields.authorPage] != JSON.null)
            ? authorJsonTransformer.transform(json: json[fields.authorPage]) : nil
        let taggedPageList = (json[fields.authorPage] != JSON.null)
            ? json[fields.taggedPageList].array?.map({ authorJsonTransformer.transform(json: $0) }) : nil
        let firstTimePublish = json[fields.firstTimePublish].bool ?? false
        return ActivityCardEntity(activityCardMessagePackage: activityCardMessagePackage, authorPage: authorPage,
                                  taggedPageList: taggedPageList, firstTimePublish: firstTimePublish)
    }
}
// swiftlint:enable identifier_name

// swiftlint:disable:next type_name
class ActivityCardMessagePackageJsonTransformer: JsonTransformer {

    private static let fields = (
        messageFormat: "messageFormat",
        argumentList: "argumentList",
        argumentNameList: "argumentNameList"
    )
    
    func transform(json: JSON) -> ActivityCardMessagePackageEntity {
        let fields = ActivityCardMessagePackageJsonTransformer.fields
        
        let messageFormat = json[fields.messageFormat].string
        let argumentList = json[fields.argumentList].array?.map({ $0.stringValue })
        let argumentNameList = json[fields.argumentNameList].array?.map({ $0.stringValue })
        
        return ActivityCardMessagePackageEntity(messageFormat: messageFormat, argumentList: argumentList,
                                                argumentNameList: argumentNameList)
    }
}
