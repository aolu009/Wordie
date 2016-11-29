//
//  ViewController.swift
//  Wordie
//
//  Created by Lu Ao on 11/21/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import MobileCoreServices
import Photos

class CameraPickerController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var movieCount = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseClient.sharedInstance.getArrayOfVideosUrlFromDatabase { (urlArray) in
            self.movieCount = (urlArray?.count)!
        }
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        takeVideo()
    }
    
    func takeVideo()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.videoQuality = UIImagePickerControllerQualityType.typeIFrame1280x720
        imagePicker.mediaTypes = [kUTTypeMovie as NSString as String]
        
        present(imagePicker, animated: true, completion:nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let url = info[UIImagePickerControllerMediaURL] as! URL
//        FirebaseClient.sharedInstance.createNewVideoObject(url: url, movieCount: self.movieCount)
        
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url )
            
        }, completionHandler:nil)
        //dissmissing the camera
        dismiss(animated: true, completion: nil)
        
        let storyboardM = UIStoryboard(name: "Malcolm.Main", bundle: nil)
        let userInputVC = storyboardM.instantiateViewController(withIdentifier: "UserInputViewController") as! UserInputViewController
        
        present(userInputVC, animated: true, completion:nil)

        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
    
    
}
