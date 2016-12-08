//
//  Word.swift
//  Dictionary
//
//  Created by Lu Ao on 11/15/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import Foundation
import UIKit

class Word: NSObject {
    var dictionary: NSDictionary?
    var word: String! = String()
    var result: [AnyObject]! //Could be multiple result??
    var lexicalEntries: [AnyObject]!
    var entries: [AnyObject]!
    var senses: [AnyObject]!
    var definition: [String] = [String]()
    var definitionAndExample:[String:String] = [String:String]()
    var testing: [String: [String:String]] = [String: [String:String]]()
    var categories: [String] = [String]()
    //var audiourlDic = [String:String]()
    var audiourl = [String]()
    var synonym = [String]()
    var antonym = [String]()
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        result = self.dictionary?["results"] as! [AnyObject]
        let temp_0 = result[0]
        lexicalEntries = temp_0["lexicalEntries"] as! [AnyObject]
        
        for temp in lexicalEntries{
            
            let category = temp["lexicalCategory"] as! String
            let pronunciations = temp["pronunciations"] as! [AnyObject]
            let audiourlDic = pronunciations[0]
            self.audiourl.append(audiourlDic["audioFile"]! as! String)
            let tempEntry = temp["entries"] as! [AnyObject]
            for sense in tempEntry{
                senses = sense["senses"] as! [NSDictionary]
                for definition in senses{
                    
                    let temp = definition as! NSDictionary
                    //print(temp)
                    if let define = temp["definitions"]{
                        let defineArray = define as! [String]
                        let defineString = defineArray[0]
                        if let exampleArrayDic = temp["examples"] as! [AnyObject]?{
                            let example = exampleArrayDic[0] as! NSDictionary //just use one example
                            let exampleString = example["text"] as! String
                            self.definitionAndExample[defineString] = exampleString
                            self.definition.append(defineString)
                            self.categories.append(category)
                            
                        }
                    }//as! [String] //FIXME: Crashes when search "test"
                    
                }
            }
            testing[category] = self.definitionAndExample
        }
        //print("Audio",self.audiourl)
    }
}
