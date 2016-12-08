//
//  WordTableViewCell.swift
//  Dictionary
//
//  Created by Lu Ao on 11/20/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit
import AVFoundation




class WordTableViewCell: UITableViewCell {

    @IBOutlet weak var word: UILabel!
    var url: String?
    
    var player: AVPlayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onPronounce(_ sender: Any) {
        play(url: self.url!)
    }
    
    
    func play(url:String) {
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
        do {
            
            let playerItem = AVPlayerItem(url: URL(string:url)!)
            self.player = try AVPlayer(playerItem:playerItem)
            player!.volume = 1.0
            player!.play()
        } catch let error as NSError {
            self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
    
}
