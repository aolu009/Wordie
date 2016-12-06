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
        
        profilePhotoImageView.layer.cornerRadius = 10
        profilePhotoImageView.clipsToBounds = true
        
        FirebaseClient.sharedInstance.getUserFromID(success: { (User) in
            self.user = User
            self.usernameLabel.text = self.user?.username

        })
        
        if let url = user?.profilePhoto {
            let converted = URL(string: url)
            profilePhotoImageView.setImageWith(converted!)
            usernameLabel.text = user?.username

        }
        
        // Do any additional setup after loading the view.
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

        imagePicker.mediaTypes = [kUTTypeMovie as NSString as String]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tabBarControllerDidSelect"), object: self)
        
        
        present(imagePicker, animated: true, completion:nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        imagePicked = info[UIImagePickerControllerOriginalImage] as? UIImage
        profilePhotoImageView.image = imagePicked   
        self.dismiss(animated: true, completion: nil)
        
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
