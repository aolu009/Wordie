//
//  FirebaseClient.swift
//  Wordie
//
//  Created by Lu Ao on 11/25/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import Foundation
import Firebase


class FirebaseClient {
    static let sharedInstance = FirebaseClient()
    private init() {}
    /*
    func searchFromOxford(searchInput: String!, success: @escaping (Word) -> Void, failure: @escaping (String) -> Void){
        
    })
    */
    func createNewUser(userEmail: String!, userID: String!, userName: String!){//, success: @escaping (Word) -> Void, failure: @escaping (String) -> Void){
        let userRef = FIRDatabase.database().reference(withPath: "users")
        let user = userRef.child(userID)
        let userNameRef = user.child("username")
        let userEmailRef = user.child("email")
        userNameRef.setValue(userName)
        userEmailRef.setValue(userEmail)
        let userProfilePic = user.child("profile_photo_url")
        userProfilePic.setValue("N/A")

    }

}

/*
 let childRef = FIRDatabase.database().reference(withPath: "movie_posts")
 //let text = ["TESTINGGGGGGG","ANOTHERRRRRRRR","HOW ABOUT THIS"]
 let movieId = childRef.child("-K2ib4H77rj0LYewF7dP")
 let movieurl = movieId.child("video_url")
 //groceryItemRef.setValue(text)
 movieurl.observe(.value, with: { snapshot in
 print("Look",snapshot.value)
 })
 
 */
