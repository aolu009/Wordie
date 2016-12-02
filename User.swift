//
//  User.swift
//  Wordie
//
//  Created by Lu Ao on 11/26/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit

let kUsernameKey = "username"
let kUserEmailKey = "email"
let kUserProfilePhotoKey = "profile_photo_url"

class User: NSObject {

    var username: String!
    var email: String!
    var profilePhoto: String!

    
    init(dictionary: NSDictionary) {
        
        if let uner = dictionary[kUsernameKey] as? String {
            username = uner
        }
        if let emal = dictionary[kUserEmailKey] as? String {
            email = emal
        }
        
        if let photo = dictionary[kUserProfilePhotoKey] as? String {
            profilePhoto = photo
        }
    }

    
}
