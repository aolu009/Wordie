//
//  NoteVideo.swift
//  Wordie
//
//  Created by Lu Ao on 12/6/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import Foundation
import UIKit

let imageUrlKey = "imageUrl"
let videoSubtitleKey = "subtitle"
let videoUrlKey = "url"

class NoteVideo: NSObject {
    
    var imageUrl: String!
    var videoSubtitle: String!
    var videoUrl: String!
    
    
    init(dictionary: NSDictionary) {
        
        if let imageUrl = dictionary[imageUrlKey] as? String {
            self.imageUrl = imageUrl
        }
        if let videoSubtitle = dictionary[videoSubtitleKey] as? String {
            self.videoSubtitle = videoSubtitle
        }
        
        if let videoUrl = dictionary[videoUrlKey] as? String {
            self.videoUrl = videoUrl
        }
    }
    
    
}
