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

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, HomeCellDelegate {
    
    @IBOutlet weak var customTableView: UITableView!
    
    @IBOutlet weak var lineMenuLine: UIView!
    var lastPlayingCell:HomeTableViewCell?
    
    @IBOutlet weak var noticationImageView: UIImageView!
    @IBOutlet weak var bottomLineMenu: UIView!
    @IBOutlet weak var forYouButton: UIButton!
    
    @IBOutlet weak var featuredButton: UIButton!
    var menuButton: UIButton!
    
    var videoArray = [MoviePost]()
    var currentMovieURL: URL?
    let refreshControl = UIRefreshControl()
    var cellForAnimationView:HomeTableViewCell?

    
    
    @IBOutlet weak var progressView: UIProgressView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bringSubview(toFront: lineMenuLine)
        view.bringSubview(toFront: forYouButton)
        view.bringSubview(toFront: featuredButton)
        view.bringSubview(toFront: progressView)
        view.bringSubview(toFront: bottomLineMenu)
        view.bringSubview(toFront: noticationImageView)

        
        
        progressView.isHidden = true
        
        
        
        fetchTimeline()
        
        // Initialize a pull to refresh UIRefreshControl
        refreshControl.addTarget(self, action: #selector(fetchTimeline), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        customTableView.insertSubview(refreshControl, at: 0)
        
        // Observe
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.LoadObserver), name: NSNotification.Name(rawValue: "Upload"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.tabBarControllerDidSelect), name: NSNotification.Name(rawValue: "tabBarControllerDidSelect"), object: nil)
    }
    
    func LoadObserver()
    {
        progressView.isHidden = false
        let observer = FirebaseClient.sharedInstance.uploadTask?.observe(.progress) { snapshot in
            // A progress event occurred
            let progress = snapshot.progress?.fractionCompleted
            print(snapshot.progress)
            // NSProgress object
            let convertedProgress = Float(progress!)
            self.progressView.progress = convertedProgress
            
        }
        
        let successObserver = FirebaseClient.sharedInstance.uploadTask?.observe(.success) { snapshot in
            print("success")
            self.progressView.isHidden = true
            
        }
    }
    
    
    
    func fetchTimeline()
    {
        FirebaseClient.sharedInstance.fetchMoviePosts { (videos) in
            self.videoArray = videos!
            self.videoArray.reverse()
            self.customTableView.reloadData()
            self.refreshControl.endRefreshing()
            
        }
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
    

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let object = object as? AVPlayer, object == lastPlayingCell?.player && keyPath == "status"
        {
            if cellForAnimationView?.player?.status == AVPlayerStatus.readyToPlay
            {
               cellForAnimationView?.pauseActivityIndicator()
                cellForAnimationView?.showControls()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeTableViewCell
        
        cellForAnimationView = cell
        let post = videoArray[indexPath.row]
        let videoURL = post.url
        
        if cell.player != nil {
            cell.player?.replaceCurrentItem(with: AVPlayerItem(url: videoURL!))
        }
        else{
            cell.player = AVPlayer(url: videoURL!)
            if cell.playerHasObserver == false {
                cell.player?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
            }
            cell.playerLayer = AVPlayerLayer(player: cell.player)
            
        }
        
        cell.shortDefintionLabel.isHidden = true
        
        cell.descriptionLabel.text = post.postBody
        cell.featuredLabel.text = post.featured
        cell.likeCountLabel.text = String(post.likes)
        cell.profilePhotoImageView.image = #imageLiteral(resourceName: "Bitmap")
        cell.subtitleLabel.text = post.subtitles
        cell.wordButton.setTitle(post.word, for: .normal)
        cell.usernameLabel.text = "@chantellepaige"
        cell.shortDefintionLabel.text = post.shortDefinition
        cell.delegate = self
        
        
        
        
        // Set the initial last playing cell value
        if lastPlayingCell == nil {
            lastPlayingCell = cell
            
        }
        
        if let pL = cell.playerLayer {
            pL.frame = self.view.frame
            
            cell.contentView.layer.addSublayer(pL)
            cell.contentView.layer.insertSublayer(cell.playerLayer!, at: 0)

            
            
            if let player = cell.player {
                player.actionAtItemEnd = .none
                
                //play first cell
                if indexPath.row == 0 {
                    //bring view back
//                    cell.contentView.layer.insertSublayer(cell.playerLayer!, at: 0)
                    cell.playVideo()
                    
                    
                }
            }
        }
        
        
        
        // Check the status and if the video is not ready to play, show activity indicator
        if cellForAnimationView?.player?.status != AVPlayerStatus.readyToPlay {
            cellForAnimationView?.startActivityIndicator()
        } else {
            cell.showControls()
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
        currentMovieURL = videoArray[(visibleIndexPath?.row)!].url
        
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
    
    
    
    
    func wordButtonTapped(word: String) {
        presentDetailView(word: word)
    }
    
    
    
    
    func presentDetailView(word: String)
    {
        var wordObject: Word?
        
        OxfordClient.sharedInstance.searchFromOxford(searchInput: word, success: {(oxfordWord) in
            if let result = oxfordWord.dictionary{
                wordObject = Word(dictionary: result)
                let vc = WordDetailViewController.instantiateCustom(word: wordObject!)
                
                let nav = UINavigationController()
                nav.viewControllers = [vc]
                //
                //               nav.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItemStyle.done, target: self, action: #selector(addTapped))
                //                Th
                //
                self.present(nav, animated: true, completion: nil)
            }
            
            
        }, failure: {(Error) in
        })
        
        
    }
    
    func getRidOfObserver(cell:HomeTableViewCell) {
        cell.player?.removeObserver(self, forKeyPath: "status", context: nil)
    }
    
    func pauseVideos()
    {
        cellForAnimationView?.pauseVideo()
        lastPlayingCell?.pauseVideo()

    }
    
    
    func tabBarControllerDidSelect(notification: NSNotification) {
        pauseVideos()
        
        
    }
    
    
    
    deinit {
        // perform the deinitialization
        cellForAnimationView?.player?.removeObserver(self, forKeyPath: "status", context: nil)
        
        // Remove the observer
        for view in customTableView.subviews {
            if let cell = view as? HomeTableViewCell {
                if cell.playerHasObserver {
                    getRidOfObserver(cell: cell)
                }
            }
        }
    }
    
    
    
}
