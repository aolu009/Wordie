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


    
//    @IBOutlet weak var userNoteVideoTableView: UITableView!
    @IBOutlet weak var wordVideoTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwipeableTableViewCell") as! SwipeableTableViewCell
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
//        cell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        

        
        
        return cell
        
    }
    
    
    
    
    
}
//    var word: Word?
//
//    var storedOffsets = [Int: CGFloat]()
//    var videoArray = [MoviePost]()
//    var finalarray = [UIImage]()
//    var soundurl: String?
//    
//    var testImage: UIImage?
//    
//    var imageArray:[String]?
//    
//
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//     
////        testImage = generatePlaceHolderImage()
////        setImageArray()
//    
//    }
////    
////    func setImageArray() {
////        //fetchtimeline
////        //iteratethroughmovies to find one wiht right word
////        //create array of those converted urls
////        var array = [URL]()
////        fetchTimeline()
////        let deadlineTime = DispatchTime.now() + .seconds(1)
////        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
////            for movie in self.videoArray{
////                if movie.word == "word" {
////                    array.append(movie.url)
////                    
////                }
////            }
////            
////            for url in array{
////                let testimage = self.generatePlaceHolderImage()
////                self.finalarray.append(self.testImage!)
////                
////            }
////        }
////        
////    }
//    
////    func fetchTimeline()
////    {
////        FirebaseClient.sharedInstance.fetchMoviePosts { (videos) in
////            self.videoArray = videos!
////            
////        }
////    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        
//        if tableView == userNoteVideoTableView {
//            return 2
//        }
//        else{
//            return 1
//        }
//        
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        if tableView == userNoteVideoTableView {
//            if section == 0{
//                return 1
//            }
//            else{
//                return 1
//            }
//            
//        }
//            
//            
//        else {
//            return 1
//        }
//        
//        
//    }
//    
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
////        if tableView == userNoteVideoTableView {
////                let cell = tableView.dequeueReusableCell(withIdentifier: "SwipeableTableViewCell") as! SwipeableTableViewCell
////                
////                return cell
////        }else {
////            let cell = tableView.dequeueReusableCell(withIdentifier: "SwipeableTableViewCell") as! SwipeableTableViewCell
//////            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
//////            cell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
////            
////            return cell
////        }
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SwipeableTableViewCell") as! SwipeableTableViewCell
//        
//        return cell
//
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: false)
//    }
//    
////    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
////        
////        
////        if tableView == userNoteVideoTableView {
////            guard let tableViewCell = cell as? SwipeableTableViewCell else { return }
////            
////            storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
////        }
////        
////    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        if tableView == userNoteVideoTableView {
//            return 100.0
//        }
//        else
//        {
//            return 80
//        }
//        
//        
//    }
//    
//}

extension VideoForNoteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return videoArray.count ?? 0
        return 40
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! VideoCollectionViewCell
        
        cell.backgroundColor = UIColor.red
        
        //        cell.placeholderImageView.image = finalarray[indexPath.row]
//        cell.placeholderImageView.image = testImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        
        //
        launchAVPlayerController()
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
        var time = CMTimeMake(1, 1)
        var imageRef = try! imageGenerator.copyCGImage(at: time, actualTime: nil)
        var thumbnail = UIImage(cgImage:imageRef)
        
        
        return thumbnail
    }
    
    func launchAVPlayerController() {
        let videoURL = NSURL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        let player = AVPlayer(url: videoURL! as URL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
            
        }
    }
    
}

