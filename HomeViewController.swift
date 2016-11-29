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
    
    
    var videoArray = [String]()
 
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bringSubview(toFront: lineMenuLine)
        view.bringSubview(toFront: forYouButton)
        view.bringSubview(toFront: featuredButton)
        
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

    
}

