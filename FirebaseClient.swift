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
    
    var uploadTask: FIRStorageUploadTask?
    
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
    


    func createNewVideoObject(url:URL, movieCount: Int, description: String, likes: Int, featured: Bool, definition: String, word: String, subtitles: String, userID: String, complete:@escaping () -> Void) -> Void {
        let videoUploadedRef = FIRStorage.storage().reference(withPath: "video_uploaded")
        
        let videoRef = videoUploadedRef.child(String(movieCount))
        
        uploadTask = videoRef.putFile(url, metadata: nil) { metadata, error in
            if (error != nil) {
                // Uh-oh, an error occurred!
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                let text = metadata!.downloadURL()?.absoluteString
                
                let token = FirebaseClient.sharedInstance.getUrlTokenString(url: text!)
                let videoPostRef = FIRDatabase.database().reference(withPath: "movie_posts")
                let videoRef = videoPostRef.child(token)
                let videoUrlRef = videoRef.child("video_url")
                videoUrlRef.setValue(text!)
                let descriptionRef = videoRef.child("description")
                descriptionRef.setValue(description)
                let likesRef = videoRef.child("likes")
                likesRef.setValue(likes)
                let featuredRef = videoRef.child("is_featured")
                featuredRef.setValue(featured)
                let defRef = videoRef.child("short_definition")
                defRef.setValue(definition)
                let subtitleRef = videoRef.child("subtitles")
                subtitleRef.setValue(subtitles)
                let userRef = videoRef.child("userID")
                userRef.setValue(userID)
                let timestampRef = videoRef.child("timestamp")
                
                let objectToSave: Dictionary<String, Any> = ["timestamp": [".sv": "timestamp"]]
                timestampRef.setValue(objectToSave)
                
                let wordRef = videoRef.child("word")
                wordRef.setValue(word)
                
                print("media url: \(text)")
                print("Token: \(token)")
                complete()
            }
        }
        let observer = uploadTask?.observe(.progress) { snapshot in
            // A progress event occurred
//            print(snapshot.progress) // NSProgress object
            
        }
    }
    
    //  Make Every info of a word arrays
    
    func getSelfDefinedDefinitionOnWord( word:String, complete:@escaping ([String]?,[Bool]?) -> Void) -> Void {
        FirebaseClient.sharedInstance.getCurrentUserId(complete: {(uid) in
            let users = FIRDatabase.database().reference(withPath: "users")
            let user = users.child(uid)
            let wordList = user.child("word_list")
            let wordToLook = wordList.child(word)
            
            wordToLook.observe(.value, with: { snapshot in
                // Need to be able to avoid "Could not cast value of type 'NSNull' (0x1a86e5588) to 'NSString' (0x1a86f0398)."
                // When no one loggin or the user is not in the database
                let definitions = snapshot.childSnapshot(forPath: "definition").value as! [String]
                var displayList = [Bool]()
                if snapshot.childSnapshot(forPath: "definitionToDisplay").exists(){
                    displayList = snapshot.childSnapshot(forPath: "definitionToDisplay").value as! [Bool]
                }
                else{
                    for _ in definitions{
                        displayList.append(true)
                    }
                }
                complete(definitions,displayList)
            })
            
        })
    }
    func getDefinitionDisplayList( word:String, complete:@escaping ([Bool]?) -> Void) -> Void {
        FirebaseClient.sharedInstance.getCurrentUserId(complete: {(uid) in
            let users = FIRDatabase.database().reference(withPath: "users")
            let user = users.child(uid)
            let wordList = user.child("word_list")
            let wordToLook = wordList.child(word)
            wordToLook.observe(.value, with: { snapshot in
                // Need to be able to avoid "Could not cast value of type 'NSNull' (0x1a86e5588) to 'NSString' (0x1a86f0398)."
                // When no one loggin or the user is not in the database
                let definitions = snapshot.childSnapshot(forPath: "definition").value as! [String]
                let displayList = snapshot.childSnapshot(forPath: "definitionToDisplay").value as! [Bool]
                /*
                if snapshot.childSnapshot(forPath: "definitionToDisplay").exists(){
                    displayList = snapshot.childSnapshot(forPath: "definitionToDisplay").value as! [Bool]
                }
                else{
                    for _ in definitions{
                        displayList.append(true)
                    }
                }
*/
                complete(displayList)
            })
            
        })
    }
    
    func getSelfDefinedExampleOnWord( word:String, complete:@escaping ([String]?,[Bool]?) -> Void) -> Void {
        FirebaseClient.sharedInstance.getCurrentUserId(complete: {(uid) in
            let users = FIRDatabase.database().reference(withPath: "users")
            let user = users.child(uid)
            let wordList = user.child("word_list")
            let wordToLook = wordList.child(word)
            wordToLook.observe(.value, with: { snapshot in
                // Need to be able to avoid "Could not cast value of type 'NSNull' (0x1a86e5588) to 'NSString' (0x1a86f0398)."
                // When no one loggin or the user is not in the database
                let examples = snapshot.childSnapshot(forPath: "example").value as! [String]
                var displayList = [Bool]()
                if snapshot.childSnapshot(forPath: "exampleToDisplay").exists(){
                    displayList = snapshot.childSnapshot(forPath: "exampleToDisplay").value as! [Bool]
                }
                else{
                    for _ in examples{
                        displayList.append(true)
                    }
                }
                complete(examples,displayList)
            })
            
        })
    }
    func getSelfDefinedSynonymOnWord( word:String, complete:@escaping ([String]?) -> Void) -> Void {
        FirebaseClient.sharedInstance.getCurrentUserId(complete: {(uid) in
            let users = FIRDatabase.database().reference(withPath: "users")
            let user = users.child(uid)
            let wordList = user.child("word_list")
            let wordToLook = wordList.child(word)
            let wordDefinition = wordToLook.child("synonym")
            wordDefinition.observe(.value, with: { snapshot in
                // Need to be able to avoid "Could not cast value of type 'NSNull' (0x1a86e5588) to 'NSString' (0x1a86f0398)."
                if let result = snapshot.value{
                    let synonym = result as! [String]
                    complete(synonym)
                }
            })
        })
    }
    func getSelfDefinedAntonymOnWord( word:String, complete:@escaping ([String]?) -> Void) -> Void {
        FirebaseClient.sharedInstance.getCurrentUserId(complete: {(uid) in
            let users = FIRDatabase.database().reference(withPath: "users")
            let user = users.child(uid)
            let wordList = user.child("word_list")
            let wordToLook = wordList.child(word)
            let wordDefinition = wordToLook.child("antonym")
            wordDefinition.observe(.value, with: { snapshot in
                // Need to be able to avoid "Could not cast value of type 'NSNull' (0x1a86e5588) to 'NSString' (0x1a86f0398)."
                if let result = snapshot.value{
                    let antonym = result as! [String]
                    complete(antonym)
                }
            })
        })
    }
    
    func addDefinitionToWord(word:String,definition:[String], complete:@escaping ([String]?) -> Void) -> Void {
        FirebaseClient.sharedInstance.getCurrentUserId(complete: {(uid) in
            let users = FIRDatabase.database().reference(withPath: "users")
            let user = users.child(uid)
            let wordList = user.child("word_list")
            let wordToLook = wordList.child(word)
            let wordDefinition = wordToLook.child("definition")
            wordDefinition.setValue(definition)
            wordToLook.observe(.value, with: { snapshot in
                let definition = snapshot.childSnapshot(forPath: "definition").value as! [String]
                complete(definition)
            })
        })
    }
    func addDefinitionDisplyList(word:String,displayList:[Bool], complete:@escaping ([Bool]?) -> Void) -> Void {
        FirebaseClient.sharedInstance.getCurrentUserId(complete: {(uid) in
            let users = FIRDatabase.database().reference(withPath: "users")
            let user = users.child(uid)
            let wordList = user.child("word_list")
            let wordToLook = wordList.child(word)
            let definitionToDisplay = wordToLook.child("definitionToDisplay")
            definitionToDisplay.setValue(displayList)
            
            
        })
    }
    
    func addExampleToWord(word:String,example:[String],displayList:[Bool],complete:@escaping ([String]?) -> Void) -> Void {
        FirebaseClient.sharedInstance.getCurrentUserId(complete: {(uid) in
            let users = FIRDatabase.database().reference(withPath: "users")
            let user = users.child(uid)
            let wordList = user.child("word_list")
            let wordToLook = wordList.child(word)
            let wordDefinition = wordToLook.child("example")
            let definitionToDisplay = wordToLook.child("exampleToDisplay")
            definitionToDisplay.setValue(displayList)
            wordDefinition.setValue(example)
            wordDefinition.observe(.value, with: { snapshot in
                let examples = snapshot.value as! [String]
                complete(examples)
            })
        })
    }
    func addSynonymToWord(word:String,synonym:String, complete:@escaping (String?) -> Void) -> Void {
        FirebaseClient.sharedInstance.getCurrentUserId(complete: {(uid) in
            let users = FIRDatabase.database().reference(withPath: "users")
            let user = users.child(uid)
            let wordList = user.child("word_list")
            let wordToLook = wordList.child(word)
            let wordDefinition = wordToLook.child("synonym")
            wordDefinition.setValue(synonym)
            wordDefinition.observe(.value, with: { snapshot in
                let synonyms = snapshot.value as! String
                complete(synonyms)
            })
        })
    }
    func addAntonymToWord(word:String,antonym:String, complete:@escaping (String?) -> Void) -> Void {
        FirebaseClient.sharedInstance.getCurrentUserId(complete: {(uid) in
            let users = FIRDatabase.database().reference(withPath: "users")
            let user = users.child(uid)
            let wordList = user.child("word_list")
            let wordToLook = wordList.child(word)
            let wordDefinition = wordToLook.child("antonym")
            wordDefinition.setValue(antonym)
            wordDefinition.observe(.value, with: { snapshot in
                let antonyms = snapshot.value as! String
                complete(antonyms)
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
/*
 /*
 for category in word.categories{
 print("\(category):")
 for definition in word.definition{
 print("Definition:",definition)
 if let ex = word.testing[category]?[definition]{
 print(ex)
 }
 }
 }
 */
 */
