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
import MarqueeLabel

protocol HomeCellDelegate: class {
    func wordButtonTapped(word: String)
}


class HomeTableViewCell: UITableViewCell {
    
    var playerHasObserver = false
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var loadingNotification: MBProgressHUD?
    var activityIndicatorView: NVActivityIndicatorView?

    weak var delegate: HomeCellDelegate?
    
    @IBOutlet weak var testlabel: MarqueeLabel!
    
    @IBOutlet weak var controlsContainerView: UIView!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var featuredLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var wordButton: UIButton!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var shortDefintionLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
      
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: "Long") //Long function will call when user long press on button.
        wordButton.addGestureRecognizer(longGesture)
        
        setupActivityIndicator()
        controlsContainerView.alpha = 0
        
//        self.testlabel.labelize = true

    }
    
    func setupActivityIndicator()
    {
        let frame = CGRect(x: 100, y: 250, width: 150, height: 150)
        
        activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                        type: (rawValue: NVActivityIndicatorType.ballPulseSync))
        activityIndicatorView?.padding = 20
        self.contentView.addSubview(activityIndicatorView!)
        activityIndicatorView?.startAnimating()

    }
    
    
    func pauseActivityIndicator()
    {
        activityIndicatorView?.stopAnimating()
        activityIndicatorView?.isHidden = true
    }
    
    func startActivityIndicator()
    {
        activityIndicatorView?.startAnimating()
        activityIndicatorView?.isHidden = false
    }
    
    func showControls() {
        UIView.animate(withDuration: 0.3, animations: {
            self.controlsContainerView.alpha = 1.0
            
        }, completion: { finished in
//            self.testlabel.labelize = false
//            self.testlabel.resetLabel()
            
            self.testlabel.labelize = false
            self.testlabel.restartLabel()



        })
    }
    
    func hideControls() {
        UIView.animate(withDuration: 0.3, animations: {
            self.controlsContainerView.alpha = 0.0
        })
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
        
        profilePhotoImageView.layer.cornerRadius = profilePhotoImageView.frame.height / 2
        profilePhotoImageView.clipsToBounds = true
        
        bringSubview(toFront: likeButton)
        bringSubview(toFront: profilePhotoImageView)
        bringSubview(toFront: likeCountLabel)
        bringSubview(toFront: reportButton)
        bringSubview(toFront: usernameLabel)
        bringSubview(toFront: featuredLabel)
        bringSubview(toFront: descriptionLabel)
        bringSubview(toFront: wordButton)
        bringSubview(toFront: controlsContainerView)
        bringSubview(toFront: testlabel)
        
        let btnFrame = wordButton.frame
        testlabel.frame = CGRect(x: btnFrame.origin.x, y: btnFrame.origin.y + 40, width: 170, height: 21)
        
        activityIndicatorView?.center = contentView.center
        
    }
    
    @IBAction func onLikeButtonTapped(_ sender: UIButton) {
        self.testlabel.labelize = false
        self.testlabel.resetLabel()

    }
    
    func Long() {
        
        print("Long press")
    }
    
    deinit {
        // perform the deinitialization
        self.player?.removeObserver(self, forKeyPath: "status", context: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        controlsContainerView.alpha = 0
    }
}
