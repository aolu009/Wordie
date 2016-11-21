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
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        result = self.dictionary?["results"] as! [AnyObject]
        let temp_0 = result[0]
        lexicalEntries = temp_0["lexicalEntries"] as! [AnyObject]
        
        for temp in lexicalEntries{
            
            let category = temp["lexicalCategory"] as! String
            //self.categories.append(category)
            let tempEntry = temp["entries"] as! [AnyObject]
            for sense in tempEntry{
                senses = sense["senses"] as! [NSDictionary]
                for definition in senses{
                    
                    let temp = definition as! NSDictionary
                    let define = temp["definitions"] as! [String] //FIXME: Crashes when search "test"
                    let defineString = define[0]
                    if let exampleArrayDic = temp["examples"] as! [AnyObject]?{
                        let example = exampleArrayDic[0] as! NSDictionary //just use one example
                        let exampleString = example["text"] as! String
                        self.definitionAndExample[defineString] = exampleString
                        self.definition.append(defineString)
                        self.categories.append(category)

                    }
                }
            }
            testing[category] = self.definitionAndExample
        }
    }
}
