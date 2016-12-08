//
//  OxfordClient.swift
//  Dictionary
//
//  Created by Lu Ao on 11/15/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import Foundation
import UIKit

class OxfordClient {
    static let sharedInstance = OxfordClient()
    private init() {}
    
    // Search method (Must fetch for words existing on Oxford dictionary, if not or typo may crash, need to play with it a lot to test corner case)
    // Due to the nature of the structure/format
    func searchFromOxford(searchInput: String!, success: @escaping (Word) -> Void, failure: @escaping (String) -> Void){
        let appId = "b8d6ad4d"
        let appKey = "52feb4b81d72db18dfccb787e77489f5"
        let language = "en"
        let word = searchInput
        let word_id = word?.lowercased() //word id is case sensitive and lowercase is required
        let urlString = "https://od-api.oxforddictionaries.com:443/api/v1/entries/\(language)/\(word_id!)"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(appId, forHTTPHeaderField: "app_id")
        request.addValue(appKey, forHTTPHeaderField: "app_key")
        //let url = URL(string:"https://wordsapiv1.p.mashape.com/words/example") //Other API
        //request.setValue("Dbn1khjYz2mshsJZ0dsAWsaDrkYgp1K6rkZjsnYje9VMziZPuq", forHTTPHeaderField: "X-Mashape-Key") //Other API
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try? JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    
                    let result = Word.init(dictionary: responseDictionary!)
                    success(result)
                }
                else{
                    print("Error: no such word!")
                    print(error)
                    /*
                     if (not in self library){
                        let errorMessage = "No such word found in Oxford. Please check your spelling or add it manually"
                     }
                     else{
                        let errorMessage = "No such word found in Oxford. Please check your spelling or add it manually"
                     }
                     */
                    let errorMessage = "No word found.\nAdd to library"
                    failure(errorMessage)
                }
            }
        })
        task.resume()
    }
    
    func syninymAntonymFromOxford(searchInput: String!, success: @escaping (SynonymAntonym) -> Void, failure: @escaping (String) -> Void){
        let appId = "b8d6ad4d"
        let appKey = "52feb4b81d72db18dfccb787e77489f5"
        let language = "en"
        let word = searchInput
        
        //https://od-api.oxforddictionaries.com:443/api/v1/entries/en/ace/synonyms;antonyms
        let word_id = word?.lowercased() //word id is case sensitive and lowercase is required
        let urlString = "https://od-api.oxforddictionaries.com:443/api/v1/entries/\(language)/\(word_id!)/synonyms;antonyms"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(appId, forHTTPHeaderField: "app_id")
        request.addValue(appKey, forHTTPHeaderField: "app_key")
        //let url = URL(string:"https://wordsapiv1.p.mashape.com/words/example") //Other API
        //request.setValue("Dbn1khjYz2mshsJZ0dsAWsaDrkYgp1K6rkZjsnYje9VMziZPuq", forHTTPHeaderField: "X-Mashape-Key") //Other API
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try? JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    
                    let result = SynonymAntonym.init(dictionary: responseDictionary!)
                    success(result)
                }
                else{
                    print("Error: no such word!")
                    print(error)
                    /*
                     if (not in self library){
                     let errorMessage = "No such word found in Oxford. Please check your spelling or add it manually"
                     }
                     else{
                     let errorMessage = "No such word found in Oxford. Please check your spelling or add it manually"
                     }
                     */
                    let errorMessage = "No word found.\nAdd to library"
                    failure(errorMessage)
                }
            }
        })
        task.resume()
    }
    
    
    
}
