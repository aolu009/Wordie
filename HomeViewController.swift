//
//  HomeViewController.swift
//  Wordie
//
//  Created by parry on 11/21/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import MobileCoreServices
import Photos

class HomeViewController: UIViewController, UITabBarDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var customTableView: UITableView!
    
    @IBOutlet weak var lineMenuLine: UIView!
    var lastPlayingCell:HomeTableViewCell?
    
    @IBOutlet weak var forYouButton: UIButton!
    
    @IBOutlet weak var featuredButton: UIButton!
    var menuButton: UIButton!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var featuredLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var wordButton: UIButton!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    var videoArray = [String]()
    var currentMovieURL = videoArray[visibleIndexPath] ?? nil

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bringSubview(toFront: lineMenuLine)
        view.bringSubview(toFront: forYouButton)
        view.bringSubview(toFront: featuredButton)
        view.bringSubview(toFront: likeButton)
        view.bringSubview(toFront: profilePhotoImageView)
        view.bringSubview(toFront: likeCountLabel)
        view.bringSubview(toFront: reportButton)
        view.bringSubview(toFront: usernameLabel)
        view.bringSubview(toFront: featuredLabel)
        view.bringSubview(toFront: descriptionLabel)
        view.bringSubview(toFront: wordButton)
        view.bringSubview(toFront: subtitleLabel)


        FirebaseClient.sharedInstance.getArrayOfVideosUrlFromDatabase { (videos) in
            self.videoArray = videos!
            self.customTableView.reloadData()
        }
        
        
        
        
        
        //setupMiddleButton()
    }
    override func viewWillAppear(_ animated: Bool){
        videoArray = [String]()
        FirebaseClient.sharedInstance.getArrayOfVideosUrlFromDatabase { (videos) in
            self.videoArray = videos!
            self.customTableView.reloadData()
        }
        self.customTableView.reloadData()
        
    }
    /*
    func setupMiddleButton() {
        menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60
        ))
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = self.view.bounds.height - menuButtonFrame.height
        menuButtonFrame.origin.x = self.view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame
        
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        self.tabBarController?.view.addSubview(menuButton)
        menuButton.addTarget(self, action: #selector(HomeViewController.takeVideo), for: UIControlEvents.touchUpInside)
        
        menuButton.setImage(#imageLiteral(resourceName: "addButton"),
                            for: UIControlState.normal)
    }
 */
    
    

    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeTableViewCell
        
        let videoURL = URL(string:videoArray[indexPath.row])
        
        if cell.player != nil {
            cell.player?.replaceCurrentItem(with: AVPlayerItem(url: videoURL!))
        }
        else{
            cell.player = AVPlayer(url: videoURL!)
            cell.playerLayer = AVPlayerLayer(player: cell.player)
            
        }
        
        // Set the initial last playing cell value
        if lastPlayingCell == nil {
            lastPlayingCell = cell
        }
        
        if let pL = cell.playerLayer {
            pL.frame = self.view.frame
            
            cell.contentView.layer.addSublayer(pL)
            
            
            
            if let player = cell.player {
                player.actionAtItemEnd = .none
                
                //play first cell
                if indexPath.row == 0 {
                    player.play()
                    
                }
            }
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return customTableView.frame.height
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // Play/Pause Video
        let visibleRect = CGRect(origin: customTableView.contentOffset, size: customTableView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath = customTableView.indexPathForRow(at: visiblePoint)
        currentMovieURL = videoArray[visibleIndexPath]

        let cell = customTableView.cellForRow(at: visibleIndexPath!) as! HomeTableViewCell
        
        
        if (cell != self.lastPlayingCell) {
            
            self.lastPlayingCell?.pauseVideo()
            self.lastPlayingCell = cell
            cell.playVideo()
        }
    }

    
    func takeVideo()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.mediaTypes = [kUTTypeMovie as NSString as String]
        
        present(imagePicker, animated: true, completion:nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let url = info[UIImagePickerControllerMediaURL]
        print("media url: \(url)")
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url as! URL)
            
        }, completionHandler:nil)
        //dissmissing the camera
        dismiss(animated: true, completion: nil)
        
    }

    @IBAction func onLikeButtonTapped(_ sender: Any) {
        
        //update moviePost
        let ref = FIRDatabase.database().reference().child("movie_posts")
        
       if currentMovieURL != nil
       {
        
        }

        
        ref.runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = FIRAuth.auth()?.currentUser?.uid {
                var stars: Dictionary<String, Bool>
                stars = post["stars"] as? [String : Bool] ?? [:]
                var starCount = post["starCount"] as? Int ?? 0
                if let _ = stars[uid] {
                    // Unstar the post and remove self from stars
                    starCount -= 1
                    stars.removeValue(forKey: uid)
                } else {
                    // Star the post and add self to stars
                    starCount += 1
                    stars[uid] = true
                }
                post["starCount"] = starCount as AnyObject?
                post["stars"] = stars as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                
                return FIRTransactionResult.success(withValue: currentData)
            }
            return FIRTransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    
    
}

