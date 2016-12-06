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
let kMovieImageKey = "imageUrl"
class MoviePost: NSObject {
    var postBody: String!
    var featured: String!
    var likes: Int!
    var shortDefinition: String!
    var subtitles: String!
    var timeStamp: String!
    var userID: String!
    var url: URL!
    var word: String!
    var imageUrl: URL!

    init(dictionary: NSDictionary) {
        
//        if let createdAtString = dictionary[kTweetCreatedAtKey] as? String {
//            let formatter = DateFormatter()
//            formatter.dateFormat = kTweetDateFormat
//            createdAt = formatter.date(from: createdAtString)
//        }
        
        if let des = dictionary[kMovieDescriptionKey] as? String {
            postBody = des
        }
        if let feat = dictionary[kMovieFeaturedKey] as? Int {
            var ft = Bool(feat as NSNumber)
            if ft == true{
                featured = "featured"

            }
        }
        
        if let like = dictionary[kMovieLikeKey] as? Int {
            likes = like
        }
        
        if let def = dictionary[kMovieDefinitionKey] as? String {
            shortDefinition = def
        }
        
        if let string = dictionary[kMovieSubtitleKey] as? String {
            subtitles = string
        }
        
        if let fav = dictionary[kMovieTimestampKey] as? String {
            timeStamp = fav
        }
        
        if let movieurl = dictionary[kMovieURLKey] as? String {
            let converted = URL(string: movieurl)
            url = converted
        }
        if let movieurl = dictionary[kMovieImageKey] as? String {
            let converted = URL(string: movieurl)
            url = converted
        }
        if let userid = dictionary[kMovieUserKey] as? String {
            userID = userid
        }
        
//        if let userDictionary = dictionary[kMovieLikeKey] as? NSDictionary {
//            user = Usr(with: userDictionary)
//        }
        
        if let movieurl = dictionary[kMovieWordKey] as? String {
            word = movieurl
        }
        
        
        
    }
    
    

}
