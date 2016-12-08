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
        
        
        imagePicked = info[UIImagePickerControllerOriginalImage] as? UIImage
        var data = Data()
        data = UIImageJPEGRepresentation(imagePicked!, 1.0)!
        FirebaseClient.sharedInstance.updateUserProfilePic(image: data, complete: {(profilePicUrl) in
            self.profilePhotoImageView.image = self.imagePicked
            print("Update Pic Complete")
            self.dismiss(animated: true, completion: nil)
            
        })
        
                
        //sendURL up to server
        
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion:nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
