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
    
    func getCurrentUserId() -> String{
        
        var userToReturn: String?
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let user = user {
                // User is signed in.
                userToReturn = user.uid
                
            } else {
                // No user is signed in.
            }
        }
        return userToReturn!
    }
    
    func getUrlTokenString(url:String) -> String {
        var tokenString: String = String()
        var startAppend: Bool = false
        var pattern: String = ""
        
        for str in url.characters {
            if pattern == "" && str == "t"{
                pattern.append(str)
            }
            else if pattern == "t" && str == "o"{
                pattern.append(str)
            }
            else if pattern == "to" && str == "k"{
                pattern.append(str)
            }
            else if pattern == "tok" && str == "e"{
                pattern.append(str)
            }
            else if pattern == "toke" && str == "n"{
                pattern.append(str)
            }
            else if pattern == "token" && str == "="{
                pattern.append(str)
            }
            else if pattern == "token="{
                startAppend = true
            }
            else {
                pattern = ""
            }
            if startAppend == true{
                tokenString.append(str)
            }
        }
        return tokenString
    }

    func getArrayOfVideosUrlFromDatabase(success: @escaping ([String]?) -> Void){
        
        var arrayOfVideoUrlString:[String] = [String]()
        let videoPostRef = FIRDatabase.database().reference(withPath: "movie_posts")
        var test: [NSDictionary] = [NSDictionary]()
        
        videoPostRef.observe(.value, with: { snapshot in
            let dic = snapshot.value as! [String:NSDictionary]
            
            for moviePost in dic {
                test.append(dic[moviePost.key]!)
            }
            
            for abc in test{
                let testingstring = abc["video_url"] as! String
                arrayOfVideoUrlString.append(testingstring)
            }
            success(arrayOfVideoUrlString)
        })
        
    }
    
    
    func createNewVideoObject(url:URL, movieCount: Int, complete:@escaping () -> Void) -> Void {
        let videoUploadedRef = FIRStorage.storage().reference(withPath: "video_uploaded")
        
        let videoRef = videoUploadedRef.child(String(movieCount))
        
        videoRef.putFile(url).observe(.success, handler: { (snapshot) in
            // When the image has successfully uploaded, we get it's download URL
            let text = snapshot.metadata?.downloadURL()?.absoluteString
            // Set the download URL to the message box, so that the user can send it to the database
            let token = FirebaseClient.sharedInstance.getUrlTokenString(url: text!)
            let videoPostRef = FIRDatabase.database().reference(withPath: "movie_posts")
            let videoRef = videoPostRef.child(token)
            let videoUrlRef = videoRef.child("video_url")
            videoUrlRef.setValue(text!)
            print("media url: \(text)")
            print("Token: \(token)")
            complete()
        })
    }
}


