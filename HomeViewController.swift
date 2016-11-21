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

class HomeViewController: UIViewController, UITabBarDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var customTableView: UITableView!
    
    @IBOutlet weak var lineMenuLine: UIView!
    var lastPlayingCell:HomeTableViewCell?
    
    
    let videoArray = ["https://firebasestorage.googleapis.com/v0/b/sixth-tempo-830.appspot.com/o/IMG_4558.MOV.mov?alt=media&token=6b860995-c0aa-4b4a-a869-bacb72dba477", "https://firebasestorage.googleapis.com/v0/b/sixth-tempo-830.appspot.com/o/IMG_4559.MOV.mov?alt=media&token=1c472a5a-6f03-4658-ba92-c986224d2457", "https://firebasestorage.googleapis.com/v0/b/sixth-tempo-830.appspot.com/o/IMG_4560.MOV.mov?alt=media&token=40f9f907-7435-4cc7-b66d-aa90c777974a"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.bringSubview(toFront: lineMenuLine)
        setupMiddleButton()
    }
    
    func setupMiddleButton() {
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = self.view.bounds.height - menuButtonFrame.height
        menuButtonFrame.origin.x = self.view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame
        
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        self.tabBarController?.view.addSubview(menuButton)
        
        menuButton.setImage(#imageLiteral(resourceName: "addButton"),
                            for: UIControlState.normal)
        menuButton.addTarget(self, action: "menuButtonAction:", for: UIControlEvents.touchUpInside)
        
        self.tabBarController?.view.layoutIfNeeded()
    }
    
    
    
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
    
    
    
}

