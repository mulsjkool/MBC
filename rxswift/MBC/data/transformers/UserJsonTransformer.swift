//
//  UserJsonTransformer.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/11/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserJsonTransformer: JsonTransformer {
    private static let fields = (
        uid: "uid",
        
        firstName: "firstName",
        lastName: "lastName",
        nickname: "nickname",
        
        active: "active",
        loginProvider: "loginProvider",
        lastLoginTimestamp: "lastLoginTimestamp",
        
        birthday: "birthDate",
        gender: "gender",
        email: "email",
        name: "name",
        photoURL: "photoURL",
        thumbnailURL: "thumbnailURL",
        profileURL: "profileURL",
        username: "username",
        phoneNumber: "phoneNumber",
        
        address: "address",
        city: "city",
        country: "country",
        state: "state",
        
        advertisement: "advertisement",
        newsletter: "newsletter",
        
        marriedStatus: "marriedStatus",
        nationality: "nationality"
    )
    
    func transform(json: JSON) -> UserProfileEntity {
        let fields = UserJsonTransformer.fields
        
        let uid = json[fields.uid].string ?? ""
        
        let firstName = json[fields.firstName].string ?? ""
        let lastName = json[fields.lastName].string ?? ""
        let nickname = json[fields.nickname].string ?? ""
        
        let active = json[fields.active].bool ?? false
        let loginProvider = json[fields.loginProvider].string ?? ""
        let lastLoginTimestamp = json[fields.lastLoginTimestamp].string ?? ""
        
        let birthdayString = json[fields.birthday].string ?? ""
        var birthday: Date?
        if !birthdayString.isEmpty {
            birthday = Date.dateFromString(string: birthdayString,
                                           format: Constants.DateFormater.BirthDayForAPI)
        }
        
        var gender = Gender.male
        if let genderStr = json[fields.gender].string {
            gender = (genderStr == Gender.male.genderCode()) ? .male : .female
        }
        
        let email = json[fields.email].string ?? ""
        let name = json[fields.name].string ?? ""
        let photoURL = json[fields.photoURL].string ?? ""
        let thumbnailURL = json[fields.thumbnailURL].string ?? ""
        let profileURL = json[fields.profileURL].string ?? ""
        let username = json[fields.username].string ?? ""
        let phoneNumber = json[fields.phoneNumber].string ?? ""
        
        let address = json[fields.address].string ?? ""
        let city = json[fields.city].string ?? ""
        let country = json[fields.country].string ?? ""
        let state = json[fields.state].string ?? ""
        
        let advertisement = json[fields.advertisement].bool ?? false
        let newsletter = json[fields.newsletter].bool ?? false
        
        let marriedStatus = json[fields.marriedStatus].string ?? ""
        let nationality = json[fields.nationality].string ?? ""
        
        return UserProfileEntity(uid: uid, firstName: firstName, lastName: lastName, nickname: nickname,
                                 active: active, loginProvider: loginProvider, lastLoginTimestamp: lastLoginTimestamp,
                                 birthday: birthday, gender: gender, email: email, name: name, photoURL: photoURL,
                                 thumbnailURL: thumbnailURL, profileURL: profileURL, username: username,
                                 phoneNumber: phoneNumber, address: address, city: city, country: country, state: state,
                                 advertisement: advertisement, newsletter: newsletter, marriedStatus: marriedStatus,
                                 nationality: nationality)
    }
}
