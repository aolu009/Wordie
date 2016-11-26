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
    
    
    let videoArray = ["https://firebasestorage.googleapis.com/v0/b/wordie-363ae.appspot.com/o/Black%20Ferrari%20Enzo%20with%20Tubi%20Exhaust%20-%20LOUD%20Acceleration.mp4?alt=media&token=c3026c76-cd7e-4976-8d61-f46fdf0657b4", "https://firebasestorage.googleapis.com/v0/b/wordie-363ae.appspot.com/o/IMG_4558.MOV.mov?alt=media&token=9631963d-0f0d-42c2-ba72-47ac12f1962c", "https://firebasestorage.googleapis.com/v0/b/wordie-363ae.appspot.com/o/IMG_4559.MOV.mov?alt=media&token=dd1435ce-cbd2-4ebc-9325-56e0550771d6", "https://firebasestorage.googleapis.com/v0/b/wordie-363ae.appspot.com/o/IMG_4560.MOV.mov?alt=media&token=eeb679fa-3e0b-4331-8b08-c7567ccdfb52"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.bringSubview(toFront: lineMenuLine)
        view.bringSubview(toFront: forYouButton)
        view.bringSubview(toFront: featuredButton)
        let childRef = FIRDatabase.database().reference(withPath: "movie_posts")
        //let text = ["TESTINGGGGGGG","ANOTHERRRRRRRR","HOW ABOUT THIS"]
        let movieId = childRef.child("-K2ib4H77rj0LYewF7dP")
        let movieurl = movieId.child("video_url")
        //groceryItemRef.setValue(text)
        movieurl.observe(.value, with: { snapshot in
            print("Look",snapshot.value)
        })
        
        //setupMiddleButton()
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
        cell.player = AVPlayer(url: videoURL!)
        cell.playerLayer = AVPlayerLayer(player: cell.player)
        
        
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
    
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity:
        CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        //find next page based on scroll
        let pageHeight = customTableView.bounds.size.height
        let videoLength = CGFloat(videoArray.count)
        
        let minSpace:CGFloat = 10
        
        var cellToSwipe = (scrollView.contentOffset.y) / (pageHeight + minSpace) + 0.5
        if cellToSwipe < 0 {
            cellToSwipe = 0
        }
        else if (cellToSwipe >= videoLength){
            cellToSwipe = videoLength - 1
        }
        let page = round(Double(Int(cellToSwipe)))
        let tabBarHeight = self.tabBarController?.tabBar.frame.height
        let y = (CGFloat(page) * customTableView.frame.size.height) + tabBarHeight! + 20
        
        let finalY = CGFloat(page) * y
        
        // set custom offset
        
        targetContentOffset.pointee.y = finalY
        
        
        
        
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

