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
        
        let videoURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/wordie-fd9cb.appspot.com/o/IMG_3445.mov?alt=media&token=d686e5c5-6f3a-4f99-a02c-fe530c7745fe")
        
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
    
    
    @IBAction func onLoginPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Malcolm.Main", bundle: nil)
        let nxtNVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        navigationController?.pushViewController(nxtNVC, animated: true)
        
    }
    
    @IBAction func onSignUpPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Malcolm.Main", bundle: nil)
        let nxtNVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        navigationController?.pushViewController(nxtNVC, animated: true)
    }
    
}
