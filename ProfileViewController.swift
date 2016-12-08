//
//  ProfileViewController.swift
//  Wordie
//
//  Created by parry on 12/6/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import Photos
import FirebaseAuth

class ProfileViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var user: User?
    
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    var imagePicked: UIImage?
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePhotoImageView.layer.cornerRadius = profilePhotoImageView.frame.height/2
        profilePhotoImageView.clipsToBounds = true
        profilePhotoImageView.image = #imageLiteral(resourceName: "frenchie")
        
        self.usernameLabel.isHidden = true
        
        fetchUser()
        
    }
    
    func fetchUser()
    {
        FirebaseClient.sharedInstance.getUserFromID(success: { (User) in
            self.user = User
            self.usernameLabel.text = "@" + (self.user?.username)!
            self.usernameLabel.isHidden = false
            if let url = self.user?.profilePhoto {
                let converted = URL(string: url)
                self.profilePhotoImageView.setImageWith(converted!)
            }
            
        })
        
    }


    @IBAction func onProfilePhotoImageViewTapped(_ sender: UITapGestureRecognizer) {
    
    presentCameraPicker()
        
    }
    
    func presentCameraPicker()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true

        imagePicker.mediaTypes = [kUTTypeImage as String]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tabBarControllerDidSelect"), object: self)
        
        
        present(imagePicker, animated: true, completion:nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            let croppedImage = cropToBounds(image: chosenImage, width: 150, height: 150)
            let imageData = UIImagePNGRepresentation(croppedImage) as NSData?

            FirebaseClient.sharedInstance.updateUserProfilePic(image: imageData as! Data, complete: {(profilePicUrl) in
                self.profilePhotoImageView.image = croppedImage
                self.dismiss(animated: true, completion: nil)

                print("Update Pic Complete")
                
            })
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion:nil)
    }

    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    @IBAction func onLogoutButtonPressed(_ sender: Any) {
        
        try! FIRAuth.auth()!.signOut()
        let storyboard = UIStoryboard(name: "Malcolm.Main", bundle: nil)
       let vc = storyboard.instantiateViewController(withIdentifier: "WelcomeNav") as! UINavigationController
            self.present(vc, animated: false, completion: nil)

    }

}
