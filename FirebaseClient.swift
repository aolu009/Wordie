//
//  FirebaseClient.swift
//  Wordie
//
//  Created by Lu Ao on 11/25/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth


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
    
    func getCurrentUserId(complete:@escaping (String)->Void){
        
        var userToReturn: String?
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let user = user {
                // User is signed in.
                userToReturn = user.uid
                complete(userToReturn!)
                print("The user now is:",userToReturn!)
                
            } else {
                print("No user is signed in")
                // No user is signed in.
            }
        }
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

    func fetchMoviePosts(success: @escaping ([MoviePost]?) -> Void){
        
        let videoPostRef = FIRDatabase.database().reference(withPath: "movie_posts")
        var posts = [MoviePost]()
        var test: [NSDictionary] = [NSDictionary]()

        
        videoPostRef.observe(.value, with: { snapshot in
            print(snapshot)
            print("Timeline retrieved")
            
            if snapshot.exists() {
                
                let dic = snapshot.value as! [String:NSDictionary]
                
                for pair in dic {
                    let mp = pair.value
                    let post = MoviePost(dictionary: mp as! NSDictionary)
                    posts.append(post)
                }
                
                success(posts)
            }
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
    
    func getSelfDefinedDefinitionOnWord(word:String, complete:@escaping (String?) -> Void) -> Void {
        FirebaseClient.sharedInstance.getCurrentUserId(complete: {(uid) in
            let users = FIRDatabase.database().reference(withPath: "users")
            let user = users.child(uid)
            let wordList = user.child("word_list")
            let wordToLook = wordList.child(word)
            let wordDefinition = wordToLook.child("definition")
            wordDefinition.observe(.value, with: { snapshot in
                // Need to be able to avoid "Could not cast value of type 'NSNull' (0x1a86e5588) to 'NSString' (0x1a86f0398)."
                if let result = snapshot.value{
                    let definition = result as! String
                    complete(definition)
                }
            })
        })
    }
    
    func addDefinitionToWord(word:String,definition:String, complete:@escaping (String?) -> Void) -> Void {
        FirebaseClient.sharedInstance.getCurrentUserId(complete: {(uid) in
            let users = FIRDatabase.database().reference(withPath: "users")
            let user = users.child(uid)
            let wordList = user.child("word_list")
            let wordToLook = wordList.child(word)
            let wordDefinition = wordToLook.child("definition")
            wordDefinition.setValue(definition)
            wordDefinition.observe(.value, with: { snapshot in
                let definition = snapshot.value as! String
                complete(definition)
            })
        
        })
    }
    func upDateMovieObjectUsingUrl(urlString:String, post:MoviePost,complete:()->Void) -> Void{
        let movieToken = FirebaseClient.sharedInstance.getUrlTokenString(url: urlString)
        let videoPostRef = FIRDatabase.database().reference(withPath: "movie_posts")
        let targetingvideoPost = videoPostRef.child(movieToken)
        let postbody = targetingvideoPost.child("postbody")
        postbody.setValue(post.postBody)
        let likes = targetingvideoPost.child("likes")
        likes.setValue(post.likes)
        let shortDefinition = targetingvideoPost.child("shortDefinition")
        shortDefinition.setValue(post.shortDefinition)
        let subtitles = targetingvideoPost.child("subtitles")
        subtitles.setValue(post.subtitles)
        let timeStamp = targetingvideoPost.child("timeStamp")
        timeStamp.setValue(post.timeStamp)
        let user = targetingvideoPost.child("user")
        user.setValue(post.userID)
        let word = targetingvideoPost.child("word")
        word.setValue(post.word)
        complete()
        //We should use the following instead to be conservative 
        //word.setValue(<#T##value: Any?##Any?#>, withCompletionBlock: <#T##(Error?, FIRDatabaseReference) -> Void#>)
    }
    
}




/*
 // Do any additional setup after loading the view.
 //let ref = FIRDatabase.database().reference(withPath: "grocery-items")
 let childRef = FIRDatabase.database().reference(withPath: "grocery-items")
 //let text = ["TESTINGGGGGGG","ANOTHERRRRRRRR","HOW ABOUT THIS"]
 let groceryItemRef = childRef.child("Let's do this")
 //groceryItemRef.setValue(text)
 groceryItemRef.observe(.value, with: { snapshot in
 })
 */

