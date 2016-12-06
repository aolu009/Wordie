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
import NVActivityIndicatorView


protocol HomeCellDelegate: class {
    func wordButtonTapped(word: String)
}


class HomeTableViewCell: UITableViewCell {
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var loadingNotification: MBProgressHUD?
    var activityIndicatorView: NVActivityIndicatorView?

    weak var delegate: HomeCellDelegate?
    
    
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
        
      
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: "Long") //Long function will call when user long press on button.
        wordButton.addGestureRecognizer(longGesture)
        
        
    }
    
    func setupActivityIndicator()
    {
        let frame = CGRect(x: 100, y: 100, width: 200, height: 200)
        
        activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                        type: (rawValue: NVActivityIndicatorType.ballPulseSync))
        activityIndicatorView?.padding = 20
        self.contentView.addSubview(activityIndicatorView!)
        activityIndicatorView?.startAnimating()

    }
    
    func pauseActivityIndicator()
    {
        activityIndicatorView?.startAnimating()

    }
    
    func playVideo() {
        if let plyr = player {
            plyr.actionAtItemEnd = .none
            plyr.play()
        }
        
        //bring view back
        contentView.layer.insertSublayer(playerLayer!, at: 1)
        
    }
    
    func pauseVideo() {
        if let plyr = player {
            plyr.actionAtItemEnd = .none
            plyr.pause()
        }
        
    }
    
    @IBAction func onWordButtonPressed(_ sender: UIButton) {
        
        let word = wordButton.titleLabel?.text
        //delegate sometimes nil
        self.delegate?.wordButtonTapped(word: word!)
        
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
    
    
    func Long() {
        
        print("Long press")
    }
    
}
