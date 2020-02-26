//
//  UserProfile.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/9/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class UserProfile: Codable, Copying {
    let uid: String
    
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
    
    //Use when update user profile
    var oldPassword: String = ""
    var newPassword: String = ""
    
    init() {
        uid = ""
        firstName = ""
        lastName = ""
        nickname = ""
        active = false
        loginProvider = ""
        lastLoginTimestamp = ""
        birthday = nil
        gender = Gender.male
        email = ""
        name = ""
        photoURL = ""
        thumbnailURL = ""
        profileURL = ""
        username = ""
        phoneNumber = ""
        address = ""
        city = ""
        country = ""
        state = ""
        advertisement = false
        newsletter = false
        marriedStatus = ""
        nationality = ""
    }
    
    init(entity: UserProfileEntity) {
        self.uid = entity.uid
        
        self.firstName = entity.firstName
        self.lastName = entity.lastName
        self.nickname = entity.nickname
        
        self.active = entity.active
        self.loginProvider = entity.loginProvider
        self.lastLoginTimestamp = entity.lastLoginTimestamp
        
        self.birthday = entity.birthday
        self.gender = entity.gender
        self.email = entity.email
        self.name = entity.name
        self.photoURL = entity.photoURL
        self.thumbnailURL = entity.thumbnailURL
        self.profileURL = entity.profileURL
        self.username = entity.username
        self.phoneNumber = entity.phoneNumber
        
        self.address = entity.address
        self.city = entity.city
        self.country = entity.country
        self.state = entity.state
        
        self.advertisement = entity.advertisement
        self.newsletter = entity.newsletter
        
        self.marriedStatus = entity.marriedStatus
        self.nationality = entity.nationality
    }
    
    required init(original: UserProfile) {
        self.uid = original.uid
        
        self.firstName = original.firstName
        self.lastName = original.lastName
        self.nickname = original.nickname
        
        self.active = original.active
        self.loginProvider = original.loginProvider
        self.lastLoginTimestamp = original.lastLoginTimestamp
        
        self.birthday = original.birthday
        self.gender = original.gender
        self.email = original.email
        self.name = original.name
        self.photoURL = original.photoURL
        self.thumbnailURL = original.thumbnailURL
        self.profileURL = original.profileURL
        self.username = original.username
        self.phoneNumber = original.phoneNumber
        
        self.address = original.address
        self.city = original.city
        self.country = original.country
        self.state = original.state
        
        self.advertisement = original.advertisement
        self.newsletter = original.newsletter
        
        self.marriedStatus = original.marriedStatus
        self.nationality = original.nationality
    }
}
