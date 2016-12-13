//
//  WelcomeViewController.swift
//  Wordie
//
//  Created by parry on 12/1/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//


import UIKit
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit
import AVFoundation

class WelcomeViewController: UIViewController, UITextFieldDelegate {
    
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var playerLooper: AVPlayerLooper?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false


        
        let videoURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/wordie-fd9cb.appspot.com/o/IMG_4904.MOV-1.mov?alt=media&token=97463f69-4a25-40ad-ae1b-7f1af6c7ff9b")
        
        
        
        if player != nil {
            player?.replaceCurrentItem(with: AVPlayerItem(url: videoURL!))
        }
        else{
            player = AVPlayer(url: videoURL!)
            playerLayer = AVPlayerLayer(player: player)

        }
        
        if let pL = playerLayer {
            pL.frame = self.view.frame
            view.layer.addSublayer(pL)
        }

        view.layer.insertSublayer(playerLayer!, at: 0)
        
        player?.isMuted = true
        player?.play()
        
        NotificationCenter.default.addObserver(self, selector: #selector(WelcomeViewController.playerItemDidReachEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        self.player?.seek(to: kCMTimeZero)
        self.player?.play()
    }
    
    @IBAction func onSignUpPressed(_ sender: UIButton) {
        pauseVideos()
        let storyboard = UIStoryboard(name: "Malcolm.Main", bundle: nil)
        let nxtNVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        navigationController?.pushViewController(nxtNVC, animated: true)
    }
    
    @IBAction func onLoginPressed(_ sender: UIButton) {
        pauseVideos()
        let storyboard = UIStoryboard(name: "Malcolm.Main", bundle: nil)
        let nxtNVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        navigationController?.pushViewController(nxtNVC, animated: true)
        
    }
    
    func pauseVideos()
    {
        player?.pause()
        
    }
    
}
