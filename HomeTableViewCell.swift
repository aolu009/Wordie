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
import MBProgressHUD


class HomeTableViewCell: UITableViewCell {

    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var loadingNotification: MBProgressHUD?

    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var featuredLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var wordButton: UIButton!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var shortDefintionLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        loadingNotification = MBProgressHUD.showAdded(to: self.contentView, animated: true)
        loadingNotification?.mode = MBProgressHUDMode.indeterminate
        loadingNotification?.label.text = "fetching :)"
        sendSubview(toBack: loadingNotification!)
    }
    
    func playVideo() {
        if let plyr = player {
            plyr.actionAtItemEnd = .none
            plyr.play()
        }
        loadingNotification?.isHidden = true
        (loadingNotification?.removeFromSuperViewOnHide)!


        //bring view back
        contentView.layer.insertSublayer(playerLayer!, at: 1)
        
        
    }
    
    func pauseVideo() {
        if let plyr = player {
            plyr.actionAtItemEnd = .none
            plyr.pause()
        }
        
    }

    
    override func layoutSubviews() {
        
        profilePhotoImageView.layer.cornerRadius = 15
        profilePhotoImageView.clipsToBounds = true
        
        bringSubview(toFront: likeButton)
        bringSubview(toFront: profilePhotoImageView)
        bringSubview(toFront: likeCountLabel)
        bringSubview(toFront: reportButton)
        bringSubview(toFront: usernameLabel)
        bringSubview(toFront: featuredLabel)
        bringSubview(toFront: descriptionLabel)
        bringSubview(toFront: wordButton)
        bringSubview(toFront: subtitleLabel)
        
        
    }


}
