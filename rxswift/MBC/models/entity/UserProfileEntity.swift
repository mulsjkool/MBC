//
//  UserProfileEntity.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/9/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class UserProfileEntity {
    var uid: String
    
    var firstName: String
    var lastName: String
    var nickname: String
    
    var active: Bool
    var loginProvider: String
    var lastLoginTimestamp: String
    
    var birthday: Date?
    var gender: Gender
    var email: String
    var name: String
    var photoURL: String
    var thumbnailURL: String
    var profileURL: String
    var username: String
    var phoneNumber: String
    
    var address: String
    var city: String
    var country: String
    var state: String
    
    var advertisement: Bool
    var newsletter: Bool
    
    var marriedStatus: String
    var nationality: String
    
    init(uid: String, firstName: String, lastName: String, nickname: String, active: Bool, loginProvider: String,
         lastLoginTimestamp: String, birthday: Date?, gender: Gender, email: String, name: String, photoURL: String,
         thumbnailURL: String, profileURL: String, username: String, phoneNumber: String, address: String, city: String,
         country: String, state: String, advertisement: Bool, newsletter: Bool, marriedStatus: String,
         nationality: String) {
        
        self.uid = uid
        
        self.firstName = firstName
        self.lastName = lastName
        self.nickname = nickname
        
        self.active = active
        self.loginProvider = loginProvider
        self.lastLoginTimestamp = lastLoginTimestamp
        
        self.birthday = birthday
        self.gender = gender
        self.email = email
        self.name = name
        self.photoURL = photoURL
        self.thumbnailURL = thumbnailURL
        self.profileURL = profileURL
        self.username = username
        self.phoneNumber = phoneNumber
        
        self.address = address
        self.city = city
        self.country = country
        self.state = state
        
        self.advertisement = advertisement
        self.newsletter = newsletter
        
        self.marriedStatus = marriedStatus
        self.nationality = nationality
    }
}
