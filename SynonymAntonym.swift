//
//  synonymAntonym.swift
//  Wordie
//
//  Created by Lu Ao on 12/7/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import Foundation
import UIKit

class SynonymAntonym: NSObject {
    
    var synonym = [String]()
    var antonym = [String]()
    
    
    init(dictionary: NSDictionary) {
        
        let result = dictionary["results"] as! [AnyObject]
        let temp_0 = result[0]
        let lexicalEntries = temp_0["lexicalEntries"] as! [AnyObject]
        for temp in lexicalEntries{
            let tempEntry = temp["entries"] as! [AnyObject]
            for sense in tempEntry{
                let senses = sense["senses"] as! [NSDictionary]
                for definition in senses{
                    let temp = definition 
                    if let define = temp["antonyms"]{
                        let defineArray = define as! [NSDictionary]
                        for defineString in defineArray{
                            let defineStringIn = defineString as! [String:String]
                            self.antonym.append(defineStringIn["text"]!)
                        }
                        
                    }
                    if let define = temp["synonyms"]{
                        let defineArray = define as! [NSDictionary]
                        for defineString in defineArray{
                            let defineStringIn = defineString as? [String:String]
                            if let defineStringIn = defineStringIn{
                            self.synonym.append((defineStringIn["text"]!))
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    
}
