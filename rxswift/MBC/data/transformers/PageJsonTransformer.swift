//
//  PageJsonTransformer.swift
//  MBC
//
//  Created by azun on 11/25/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
import SwiftyJSON

class PageJsonTransformer: JsonTransformer {

    private static let fields = (
        id : "id",
        title : "title",
        logo : "logo",
        externalUrl : "externalUrl",
        gender: "gender",
        accentColor: "accentColor",
        posterUrl: "posterUrl",
        logoURL: "logoURL"
    )

    func transform(json: JSON) -> PageEntity {
        let fields = PageJsonTransformer.fields

        let id = json[fields.id].stringValue
        let title = json[fields.title].stringValue
        var logo = json[fields.logo].string ?? ""
        if logo.isEmpty {
            logo = json[fields.logoURL].string ?? ""
        }
        let externalUrl = json[fields.externalUrl].stringValue
        let gender = json[fields.gender].string ?? ""
        let accentColor = json[fields.accentColor].string
        let posterUrl = json[fields.posterUrl].string ?? ""
        return PageEntity(id: id, title: title, logo: logo, externalUrl: externalUrl, gender: gender,
                          accentColor: accentColor, posterUrl: posterUrl)
    }
}
