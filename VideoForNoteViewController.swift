//
//  VideoForNoteViewController.swift
//  Wordie
//
//  Created by Lu Ao on 12/4/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit
import Firebase
import AFNetworking
import AVFoundation
import AVKit



class VideoForNoteViewController: UIViewController, UITabBarControllerDelegate, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var wordText: UILabel!
    
    @IBOutlet weak var wordVideoTableView: UITableView!
    @IBOutlet weak var userNoteVideoTableView: UITableView!
    var videoArray = [NoteVideo]()
    var word: String?
    var pronounce: String?
    
    override func viewDidLoad() {
        self.wordText.text = self.word
        FirebaseClient.sharedInstance.fetchWordVideos(word: word!, success:{ (videos) in
            self.videoArray = videos!
            self.userNoteVideoTableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if tableView == userNoteVideoTableView{
            if videoArray.count > 0{
                return videoArray.count
            }
            else{
                return 0
            }
            
        }
         else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == userNoteVideoTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoForNoteTableViewCell") as! VideoForNoteTableViewCell
            cell.videoPreview.image = generatePlaceHolderImage()
            cell.videoSentence.text = self.videoArray[indexPath.row].videoSubtitle
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwipeableTableViewCell") as! SwipeableTableViewCell
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == userNoteVideoTableView{
            let url = self.videoArray[indexPath.row].videoUrl
            print("Selected",self.videoArray[indexPath.row].videoUrl)//
            launchAVPlayerController(videoURL: URL(string:url!)! )
            
        }
    }
    
    
    
    
    
}

extension VideoForNoteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return videoArray.count ?? 0
        return 5
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteCell", for: indexPath) as! VideoCollectionViewCell
        cell.placeholderImageView.image = generatePlaceHolderImage()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        let videoURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/wordie-fd9cb.appspot.com/o/Black%20Ferrari%20Enzo%20with%20Tubi%20Exhaust%20-%20LOUD%20Acceleration.mp4?alt=media&token=872f91fc-e863-4e15-8f0d-ef8642e4b8d7")
        launchAVPlayerController(videoURL: videoURL!)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        
        let size = CGSize(width: 80, height: 72)
        return size
    }
    
    func generatePlaceHolderImage() -> UIImage
    {
        let videoURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/wordie-fd9cb.appspot.com/o/IMG_3445.mov?alt=media&token=d686e5c5-6f3a-4f99-a02c-fe530c7745fe")
        
        
        var sourceURL = videoURL
        var asset = AVAsset(url: sourceURL!)
        var imageGenerator = AVAssetImageGenerator(asset: asset)
        var time = CMTimeMake(5, 5)
        var imageRef = try! imageGenerator.copyCGImage(at: time, actualTime: nil)
        var thumbnail = UIImage(cgImage:imageRef)
        
        
        return thumbnail
    }
    
    func launchAVPlayerController(videoURL: URL) {
        
        //let videoURL = NSURL(string: url)
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
            
        }
    }
    
}
