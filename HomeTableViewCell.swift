//
//  HomeTableViewCell.swift
//  Wordie
//
//  Created by parry on 11/21/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class HomeTableViewCell: UITableViewCell {

    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func playVideo() {
        if let plyr = player {
            plyr.actionAtItemEnd = .none
            plyr.play()
        }
        
        
    }
    
    func pauseVideo() {
        if let plyr = player {
            plyr.actionAtItemEnd = .none
            plyr.pause()
        }
        
    }


}
