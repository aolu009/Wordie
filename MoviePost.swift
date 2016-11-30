//
//  MoviePost.swift
//  Wordie
//
//  Created by parry on 11/28/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit

let kMovieDescriptionKey = "description"
let kMovieCreatedAtKey = "created_at"
let kMovieFeaturedKey = "is_featured"
let kMovieLikeKey = "likes"
let kMovieDateFormat = "EEE MMM d HH:mm:ss Z y"
let kMovieDefinitionKey = "short_definition"
let kMovieSubtitleKey = "subtitles"
let kMovieTimestampKey = "timestamp"
let kMovieUserKey = "userID"
let kMovieURLKey = "video_url"
let kMovieWordKey = "word"

class MoviePost: NSObject {
    var postBody: String!
    var featured: Bool!
    var likes: NSNumber!
    var shortDefinition: String!
    var subtitles: String!
    var timeStamp: String!
    var user: User!
    var url: URL!
    var word: String!

    init(dictionary: NSDictionary) {
        text = dictionary[kTweetTextKey] as? String
        
        if let createdAtString = dictionary[kTweetCreatedAtKey] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = kTweetDateFormat
            createdAt = formatter.date(from: createdAtString)
        }
        
        if let count = dictionary[kTweetRetweetCountKey] as? Int {
            retweetCount = count
        }
        if let count = dictionary[kTweetFavoritesCountKey] as? Int {
            favourtiesCount = count
        }
        
        if let userDictionary = dictionary[kTweetUserKey] as? NSDictionary {
            user = TRUser(with: userDictionary)
        }
        
        if let count = dictionary[kTweetIDKey] as? CLong {
            id = count
        }
        
        if let string = dictionary[kTweetIDStringKey] as? String {
            idString = string
        }
        
        if let fav = dictionary[kTweetFavouritedKey] as? Bool {
            favourited = fav
        }
        
        if let movieurl = dictionary[kMovieURLKey] as? Bool {
            url = movieurl
        }
        
    }
    
    

}
