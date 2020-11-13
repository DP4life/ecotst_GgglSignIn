//
//  SignUpViewController.swift
//  Eco
//
//  Created by Porcescu Artiom on 8/28/20.
//  Copyright © 2020 EcoHelpers. All rights reserved.
//

import UIKit
import Photos
import Firebase
import FirebaseStorage

class SignUpViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var tapToChangeButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userNameTextField.backgroundColor = .clear
        userNameTextField.layer.cornerRadius = 27
        userNameTextField.layer.borderWidth = 1
        userNameTextField.layer.borderColor = UIColor.systemGreen.cgColor
        
        emailTextField.backgroundColor = .clear
        emailTextField.layer.cornerRadius = 27
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.systemGreen.cgColor
        
        passwordTextField.backgroundColor = .clear
        passwordTextField.layer.cornerRadius = 27
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.systemGreen.cgColor
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(imageTap)
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
        tapToChangeButton.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        
        imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        checkPermissions()
    }
    
    @objc func openImagePicker(_ sender:Any) {
        // Open Image Picker
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func checkPermissions() {
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({ (status:
                PHAuthorizationStatus) -> Void in
                ()
            })
        }
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
        } else {
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    
    func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            print("Have authorization")
        } else {
            print("Authorization declined")
        }
    }
    
    @IBAction func signupPressed(_ sender: UIButton) {
        
            guard let username = self.userNameTextField.text, username.count > 3 else {
                self.errorLabel.text = "Please enter a valid username"
                return
            }

            guard let password = passwordTextField.text else {
                self.errorLabel.text = "Please enter a valid password"
                return
            }

            guard let email = emailTextField.text else {
                self.errorLabel.text = "Please enter a valid email"
                return
            }

        guard let image = profileImageView.image else { return }
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.errorLabel.text = e.localizedDescription
                } else {
                    self.uploadToCloud(with: image)
                    //Navigate to the ChatViewController
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["username": username, "uid": authResult!.user.uid]) { (error) in
                        if let e = error {
                            // You may not want to show this error to the user but you should still show a "sanitised" error so that it doesn't leak information.
                            self.errorLabel.text = e.localizedDescription
                        } else {
                            self.performSegue(withIdentifier: "goToMap", sender: self)
                        }
                    }
                }
            }
        }
    
    func uploadToCloud(with profileImage:UIImage) {

    let storage = Storage.storage().reference()
    guard let uid = Auth.auth().currentUser?.uid else { return }
    guard  let imageData = profileImage.jpegData(compressionQuality: 0.75) else {
        return
    }
        
    let metaData = StorageMetadata()
    metaData.contentType = "image/jpg"
        
        storage.child("users/\(uid).jpg").putData(imageData, metadata: metaData) { (StorageMetadata, error) in
        guard StorageMetadata != nil else{
            print("oops an error occured while data uploading")
            return
        }
             print("Image sent")
        }
        
    }
    
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.profileImageView.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
