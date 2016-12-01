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
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var currentUserID: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let videoURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/wordie-363ae.appspot.com/o/IMG_4558.MOV.mov?alt=media&token=9631963d-0f0d-42c2-ba72-47ac12f1962c")
        
        
        
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
        
        
    }
    

        @IBAction func onLoginPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Malcolm.Main", bundle: nil)
        let nxtNVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present( nxtNVC, animated: true, completion: nil)

    }
    
    @IBAction func onSignUpPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Malcolm.Main", bundle: nil)
        let nxtNVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.present( nxtNVC, animated: true, completion: nil)
        

    }
    
    
}
