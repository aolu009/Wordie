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

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        takeVideo()
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
        let videoRef = FIRStorage.storage().reference(withPath: "Exapmle_Testing.mov")
        videoRef.putFile(url as! URL).observe(.success, handler: { (snapshot) in
            // When the image has successfully uploaded, we get it's download URL
            let text = snapshot.metadata?.downloadURL()?.absoluteString
            // Set the download URL to the message box, so that the user can send it to the database
            print("media url: \(text)")
        })
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url as! URL)
            
        }, completionHandler:nil)
        //dissmissing the camera
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
    
    
}
