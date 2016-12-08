//
//  FirebaseClient.swift
//  Wordie
//
//  Created by Lu Ao on 11/25/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import Foundation
import Firebase
import AVFoundation
import FirebaseAuth


class FirebaseClient {
    static let sharedInstance = FirebaseClient()
    private init() {}
    
    var uploadTask: FIRStorageUploadTask?
    
    func createNewUser(userEmail: String!, userID: String!, userName: String!, photoURL: String!){//, success: @escaping (Word) -> Void, failure: @escaping (String) -> Void){
        let userRef = FIRDatabase.database().reference(withPath: "users")
        let user = userRef.child(userID)
        let userNameRef = user.child("username")
        let userEmailRef = user.child("email")
        userNameRef.setValue(userName)
        userEmailRef.setValue(userEmail)
        let userProfilePic = user.child("profile_photo_url")
        userProfilePic.setValue(photoURL)

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
    
    
    
    func updateUsername(username: String)
    {
        let userID = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference()
        var user:User?
        ref.child("users").child(userID!).setValue(["username": username])
        
    }
    
    func getUserFromID(success: @escaping (User) -> Void)
    {
        let userID = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference()
        var user:User?
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            user = User.init(dictionary: value!)
            success(user!)

            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func getUserWithID(id: String, success: @escaping (User) -> Void)
    {
        let userID = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference()
        var user:User?
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            user = User.init(dictionary: value!)
            success(user!)
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
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
        videoPostRef.observe(.value, with: { snapshot in
            print(snapshot)
            print("Timeline retrieved")
            
            if snapshot.exists() {
                
                let dic = snapshot.value as! [String:NSDictionary]
                
                for pair in dic {
                    let mp = pair.value
                    let post = MoviePost(dictionary: mp)
                    posts.append(post)
                }
                
                success(posts)
            }
        })
    }
    func fetchWordVideos(word:String,success: @escaping ([NoteVideo]?) -> Void){
        FirebaseClient.sharedInstance.getCurrentUserId(complete: {(uid) in
            let users = FIRDatabase.database().reference(withPath: "users")
            let user = users.child(uid)
            let wordList = user.child("word_list")
            let wordToLook = wordList.child(word)
            let videoPostRef = wordToLook.child("videos")
            var posts = [NoteVideo]()
            videoPostRef.observe(.value, with: { snapshot in
                print("User Word",snapshot)
                if snapshot.exists() {
                    let dic = snapshot.value as! [String:NSDictionary]
                    print("User Word",dic)
                    for pair in dic {
                        let mp = pair.value
                        let post = NoteVideo(dictionary: mp )
                        posts.append(post)
                    }
                    success(posts)
                }
            })
        })
        
    }
    func updateUserProfilePic(image: Data, complete:@escaping (String?)->Void) -> Void{
        FirebaseClient.sharedInstance.getCurrentUserId(complete: {(uid) in
            let profilePics = FIRStorage.storage().reference(withPath: "profilePics")
            let userProfilePic = profilePics.child(uid)
            print("Got user Id")
            userProfilePic.put(image, metadata: nil, completion: { (metadata, error) in
                print("Put file into storage")
                let users = FIRDatabase.database().reference(withPath: "users")
                let user = users.child(uid)
                let profilePicRef = user.child("profile_photo_url")
                let picDownloadUrl = metadata?.downloadURL()?.absoluteString
                profilePicRef.setValue(picDownloadUrl, withCompletionBlock: { (error, reference) in
                    complete(picDownloadUrl)
                    print("update Complete")
                })
                
            })
        })
        
    }
    
    
    
    func generatePlaceHolderImage(url:String) -> UIImage
    {
        let imageUrl = URL(string:url)
        let asset = AVAsset(url: imageUrl!)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        let time = CMTimeMake(1, 1)
        let imageRef = try! imageGenerator.copyCGImage(at: time, actualTime: nil)
        let thumbnail = UIImage(cgImage:imageRef)
        return thumbnail
    }

    func createNewVideoObject(url:URL, movieCount: Int, description: String, likes: Int, featured: Bool, definition: String, word: String, subtitles: String, userID: String, complete:@escaping () -> Void) -> Void {
        
        let videoUploadedRef = FIRStorage.storage().reference(withPath: "video_uploaded")
        let videoPicsRef = FIRStorage.storage().reference(withPath:"place_holder_pics")
        
        let videoRef = videoUploadedRef.child(String(movieCount))
        
        uploadTask = videoRef.putFile(url, metadata: nil) { metadata, error in
            if (error != nil) {
                // Uh-oh, an error occurred!
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                let text = metadata!.downloadURL()?.absoluteString
                let token = FirebaseClient.sharedInstance.getUrlTokenString(url: text!)
                let videoImage = self.generatePlaceHolderImage(url: text!)
                let imageData = UIImagePNGRepresentation(videoImage)
                let picRef = videoPicsRef.child(token)
                
                picRef.put(imageData! as Data, metadata: nil, completion: { (metadata, error) in
                    print("image uploaded!!")
                
                let imageUrl = metadata!.downloadURL()?.absoluteString
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
                
                
                let users = FIRDatabase.database().reference(withPath: "users")
                let user = users.child(userID)
                let wordList = user.child("word_list")
                let wordToLook = wordList.child(word)
                let wordVideos = wordToLook.child("videos")
                let newVideo = wordVideos.child(token)
                let videoToken = newVideo.child("token")
                let videoSubtitle = newVideo.child("subtitle")
                let videoUrl = newVideo.child("url")
                let picUrl = newVideo.child("imageUrl")
                videoToken.setValue(token)
                videoSubtitle.setValue(subtitles)
                videoUrl.setValue(text!)
                picUrl.setValue(imageUrl)
                complete()
                })
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
                if snapshot.childSnapshot(forPath: "definition").exists() {
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
                }
                else{
                    let definitions = [String]()
                    let displayList = [Bool]()
                    complete(definitions,displayList)
                }
                
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
                if snapshot.childSnapshot(forPath: "definitionToDisplay").exists(){
                    let displayList = snapshot.childSnapshot(forPath: "definitionToDisplay").value as! [Bool]
                    complete(displayList)
                }
                else{
                    let displayList = [Bool]()
                    complete(displayList)
                }
                
            })
            
        })
    }
    func getExampleDisplayList( word:String, complete:@escaping ([Bool]?) -> Void) -> Void {
        FirebaseClient.sharedInstance.getCurrentUserId(complete: {(uid) in
            let users = FIRDatabase.database().reference(withPath: "users")
            let user = users.child(uid)
            let wordList = user.child("word_list")
            let wordToLook = wordList.child(word)
            wordToLook.observe(.value, with: { snapshot in
                // Need to be able to avoid "Could not cast value of type 'NSNull' (0x1a86e5588) to 'NSString' (0x1a86f0398)."
                // When no one loggin or the user is not in the database
                if snapshot.childSnapshot(forPath: "exampleToDisplay").exists(){
                    let displayList = snapshot.childSnapshot(forPath: "exampleToDisplay").value as! [Bool]
                    complete(displayList)
                }
                else{
                    let displayList = [Bool]()
                    complete(displayList)
                }
                
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
                if snapshot.childSnapshot(forPath: "example").exists(){
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
                }
                else{
                    let examples = [String]()
                    let displayList = [Bool]()
                    complete(examples,displayList)
                }
            })
            
        })
    }
    func getSelfDefinedSynonymOnWord( word:String, complete:@escaping ([String]?,[Bool]?) -> Void) -> Void {
        FirebaseClient.sharedInstance.getCurrentUserId(complete: {(uid) in
            let users = FIRDatabase.database().reference(withPath: "users")
            let user = users.child(uid)
            let wordList = user.child("word_list")
            let wordToLook = wordList.child(word)
            wordToLook.observe(.value, with: { snapshot in
                // Need to be able to avoid "Could not cast value of type 'NSNull' (0x1a86e5588) to 'NSString' (0x1a86f0398)."
                if snapshot.childSnapshot(forPath: "synonym").exists(){
                    let synonyms = snapshot.childSnapshot(forPath: "synonym").value as! [String]
                    var displayList = [Bool]()
                    if snapshot.childSnapshot(forPath: "synonymToDisplay").exists(){
                        displayList = snapshot.childSnapshot(forPath: "synonymToDisplay").value as! [Bool]
                    }
                    else{
                        for _ in synonyms{
                            displayList.append(true)
                        }
                    }
                    complete(synonyms,displayList)
                }
                else{
                    let synonyms = [String]()
                    let displayList = [Bool]()
                    complete(synonyms,displayList)
                }
            })
        })
    }
    func getSynonymDisplayList( word:String, complete:@escaping ([Bool]?) -> Void) -> Void {
        FirebaseClient.sharedInstance.getCurrentUserId(complete: {(uid) in
            let users = FIRDatabase.database().reference(withPath: "users")
            let user = users.child(uid)
            let wordList = user.child("word_list")
            let wordToLook = wordList.child(word)
            wordToLook.observe(.value, with: { snapshot in
                // Need to be able to avoid "Could not cast value of type 'NSNull' (0x1a86e5588) to 'NSString' (0x1a86f0398)."
                if snapshot.childSnapshot(forPath: "synonymToDisplay").exists(){
                    let synonymToDisplay = snapshot.childSnapshot(forPath: "synonymToDisplay").value as! [Bool]
                    complete(synonymToDisplay)
                }
                else{
                    let displayList = [Bool]()
                    complete(displayList)
                }
            })
        })
    }
    func getSelfDefinedAntonymOnWord( word:String, complete:@escaping ([String]?,[Bool]?) -> Void) -> Void {
        FirebaseClient.sharedInstance.getCurrentUserId(complete: {(uid) in
            let users = FIRDatabase.database().reference(withPath: "users")
            let user = users.child(uid)
            let wordList = user.child("word_list")
            let wordToLook = wordList.child(word)
            wordToLook.observe(.value, with: { snapshot in
                // Need to be able to avoid "Could not cast value of type 'NSNull' (0x1a86e5588) to 'NSString' (0x1a86f0398)."
                if snapshot.childSnapshot(forPath: "antonym").exists(){
                    let antonyms = snapshot.childSnapshot(forPath: "antonym").value as! [String]
                    var displayList = [Bool]()
                    if snapshot.childSnapshot(forPath: "antonymToDisplay").exists(){
                        displayList = snapshot.childSnapshot(forPath: "antonymToDisplay").value as! [Bool]
                    }
                    else{
                        for _ in antonyms{
                            displayList.append(true)
                        }
                    }
                    complete(antonyms,displayList)
                }
                else{
                    let antonyms = [String]()
                    let displayList = [Bool]()
                    complete(antonyms,displayList)
                }
            })
        })
    }
    func getAntonymDisplayList( word:String, complete:@escaping ([Bool]?) -> Void) -> Void {
        FirebaseClient.sharedInstance.getCurrentUserId(complete: {(uid) in
            let users = FIRDatabase.database().reference(withPath: "users")
            let user = users.child(uid)
            let wordList = user.child("word_list")
            let wordToLook = wordList.child(word)
            wordToLook.observe(.value, with: { snapshot in
                // Need to be able to avoid "Could not cast value of type 'NSNull' (0x1a86e5588) to 'NSString' (0x1a86f0398)."
                if snapshot.childSnapshot(forPath: "antonymToDisplay").exists(){
                    let antonymToDisplay = snapshot.childSnapshot(forPath: "antonymToDisplay").value as! [Bool]
                    complete(antonymToDisplay)
                }
                else{
                    let displayList = [Bool]()
                    complete(displayList)
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
    
    func addExampleToWord(word:String,example:[String],complete:@escaping ([String]?) -> Void) -> Void {
        FirebaseClient.sharedInstance.getCurrentUserId(complete: {(uid) in
            let users = FIRDatabase.database().reference(withPath: "users")
            let user = users.child(uid)
            let wordList = user.child("word_list")
            let wordToLook = wordList.child(word)
            let wordDefinition = wordToLook.child("example")
            wordDefinition.setValue(example)
        })
    }
    func addExampleDisplyList(word:String,displayList:[Bool],complete:@escaping ([String]?) -> Void) -> Void {
        FirebaseClient.sharedInstance.getCurrentUserId(complete: {(uid) in
            let users = FIRDatabase.database().reference(withPath: "users")
            let user = users.child(uid)
            let wordList = user.child("word_list")
            let wordToLook = wordList.child(word)
            let definitionToDisplay = wordToLook.child("exampleToDisplay")
            definitionToDisplay.setValue(displayList)
        })
    }
    func addSynonymToWord(word:String,synonym:[String], complete:@escaping ([String]?) -> Void) -> Void {
        FirebaseClient.sharedInstance.getCurrentUserId(complete: {(uid) in
            let users = FIRDatabase.database().reference(withPath: "users")
            let user = users.child(uid)
            let wordList = user.child("word_list")
            let wordToLook = wordList.child(word)
            let wordDefinition = wordToLook.child("synonym")
            wordDefinition.setValue(synonym)
            wordDefinition.observe(.value, with: { snapshot in
                let synonyms = snapshot.value as! [String]
                complete(synonyms)
            })
        })
    }
    func addSynonymDisplyList(word:String,displayList:[Bool], complete:@escaping (String?) -> Void) -> Void {
        FirebaseClient.sharedInstance.getCurrentUserId(complete: {(uid) in
            let users = FIRDatabase.database().reference(withPath: "users")
            let user = users.child(uid)
            let wordList = user.child("word_list")
            let wordToLook = wordList.child(word)
            let wordDefinition = wordToLook.child("synonymToDisplay")
            wordDefinition.setValue(displayList)
        })
    }
    func addAntonymToWord(word:String,antonym:[String], complete:@escaping ([String]?) -> Void) -> Void {
        FirebaseClient.sharedInstance.getCurrentUserId(complete: {(uid) in
            let users = FIRDatabase.database().reference(withPath: "users")
            let user = users.child(uid)
            let wordList = user.child("word_list")
            let wordToLook = wordList.child(word)
            let wordDefinition = wordToLook.child("antonym")
            wordDefinition.setValue(antonym)
            wordDefinition.observe(.value, with: { snapshot in
                let antonyms = snapshot.value as! [String]
                complete(antonyms)
            })
        })
    }
    func addAntonymDisplyList(word:String,displayList:[Bool], complete:@escaping (String?) -> Void) -> Void {
        FirebaseClient.sharedInstance.getCurrentUserId(complete: {(uid) in
            let users = FIRDatabase.database().reference(withPath: "users")
            let user = users.child(uid)
            let wordList = user.child("word_list")
            let wordToLook = wordList.child(word)
            let wordDefinition = wordToLook.child("antonymToDisplay")
            wordDefinition.setValue(displayList)
        })
    }
    
    func getUserWordVideoArray(word:String, complete:@escaping ([[String:String]]?) -> Void)-> Void{
        FirebaseClient.sharedInstance.getCurrentUserId(complete: {(uid) in
            let users = FIRDatabase.database().reference(withPath: "users")
            let user = users.child(uid)
            let wordList = user.child("word_list")
            let wordToLook = wordList.child(word)
            wordToLook.observe(.value, with: { snapshot in
                // Need to be able to avoid "Could not cast value of type 'NSNull' (0x1a86e5588) to 'NSString' (0x1a86f0398)."
                if snapshot.childSnapshot(forPath: "videos").exists(){
                    let videos = snapshot.childSnapshot(forPath: "antonymToDisplay").value as! [[String:String]]
                    complete(videos)
                }
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

extension String {
    func regex (pattern: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options(rawValue: 0))
            let nsstr = self as NSString
            let all = NSRange(location: 0, length: nsstr.length)
            var matches : [String] = [String]()
            regex.enumerateMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: all) {
                (result : NSTextCheckingResult?, _, _) in
                if let r = result {
                    let result = nsstr.substring(with: r.range) as String
                    matches.append(result)
                }
            }
            return matches
        } catch {
            return [String]()
        }
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
