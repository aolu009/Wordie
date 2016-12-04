//
//  WordDetailViewController.swift
//  Dictionary
//
//  Created by Lu Ao on 11/19/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//
//Got to step up container View
//
import UIKit
import Firebase
import AFNetworking
import AVFoundation
import AVKit

protocol WordDetailViewControllerDataSource {
    func wordDetailViewController() -> Word
}




class WordDetailViewController: UIViewController, UITabBarControllerDelegate, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var definitionTable: UITableView!
    var word: Word?
    var dataSource: WordDetailViewControllerDataSource?
    var storedOffsets = [Int: CGFloat]()
    var videoArray = [MoviePost]()
    var finalarray = [UIImage]()

    
    var testImage: UIImage?
    
    var imageArray:[String]?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        definitionTable.delegate = self
        definitionTable.dataSource = self
        /*
        // checking if word info load properly
        if let word = self.word{ //dataSource?.wordDetailViewController()
            for category in word.categories{
                print("\(category):")
                for definition in word.definition{
                    print("Definition:",definition)
                    if let ex = word.testing[category]?[definition]{
                        print(ex)
                    }
                }
            }
        }
        else{
            print("Nothing Passed to hereeeeeeeeeee")
        }
        */
        definitionTable.reloadData()
        
       testImage = generatePlaceHolderImage()
        setImageArray()
        
        
    }
    
    func setImageArray() {
        //fetchtimeline
        //iteratethroughmovies to find one wiht right word
        //create array of those converted urls
        var array = [URL]()
        fetchTimeline()
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            for movie in self.videoArray{
                if movie.word == "word" {
                    array.append(movie.url)
                    
                }
            }
            
            for url in array{
                let testimage = self.generatePlaceHolderImage()
                self.finalarray.append(self.testImage!)
                
            }
        }
        
    }
    
    func fetchTimeline()
    {
        FirebaseClient.sharedInstance.fetchMoviePosts { (videos) in
            self.videoArray = videos!
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 1
        }
        else if section == 1{
            return (word?.definition.count)!
        }
        else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)

    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "WordTableViewCell") as! WordTableViewCell
            if let word = self.word{
                cell.word.text = word.word
            }
            return cell
        }
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefinitionTableViewCell") as! DefinitionTableViewCell
            if let word = self.word{
                cell.categoryText.text = word.categories[indexPath.row]
                cell.definitionText.text = word.definition[indexPath.row]
                cell.exampleText.text = word.definitionAndExample[word.definition[indexPath.row]]
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwipeableTableViewCell") as! SwipeableTableViewCell
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            cell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0

            return cell

        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2{
            guard let tableViewCell = cell as? SwipeableTableViewCell else { return }
            
            storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
        }
    }

    
    @IBAction func onSearch(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Louis.Main", bundle: nil)
        let nxtNVC = storyboard.instantiateViewController(withIdentifier: "SearchTabViewController") as! SearchTabViewController
        //let nxtVC = nxtNVC.topViewController as! EditDetailViewController
        //nxtVC.dataSource = self
        self.present( nxtNVC, animated: true, completion: {
            //self.dismiss(animated: true, completion: nil)
            
        })
        //self.dismiss(animated: true, completion: nil)
    }
    
}


extension WordDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return videoArray.count ?? 0
        return 40

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! VideoCollectionViewCell
        
//        cell.placeholderImageView.image = finalarray[indexPath.row]
        cell.placeholderImageView.image = testImage

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        
        //
        launchAVPlayerController()
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
