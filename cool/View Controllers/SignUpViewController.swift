//
//  SignUpViewController.swift
//  cool
//
//  Created by Nadia Leung on 1/16/20.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var updateProfilePhoto: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var imagePicker:UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpElements()
        
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker(_:)))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(imageTap)
        profileImageView.clipsToBounds = true
        updateProfilePhoto.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
    }
    
    func setUpElements() {
        //Hide error label
        errorLabel.alpha = 0
        
        //Style texts
        Utilities.styleTextField(usernameTextField)
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
        
    }

    //Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    func validateFields() -> String? {
        
        //Check that all fields are filled in
        if  usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        // Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            
            return "Password must be at least 8 characters long, contain a special character and a number."
        }
        
        return nil
    }
    
    @objc func openImagePicker(_ sender: Any) {
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }

    
    @IBAction func signUpTapped(_ sender: Any) {
        
        //validate the fields
        let error = validateFields()
        
        if error != nil {
            
            showError(error!)
          
        } else {
            
            // Create cleaned versions of the data
            let userName = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            guard let image = profileImageView.image else { return }
            
            
            
            //create the user //result and error optionals
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                // Check for errors
               
                if error != nil && user == nil {
                    // There was an error creating the user
                    self.showError("Error creating user")
                    
                } else {
                    
                    //1. Upload the profile image to firebase storage
                    self.uploadProfile(image) { url in
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = userName
                        changeRequest?.photoURL = url
                        
                        changeRequest?.commitChanges { error in
                            if error == nil {
                                print("Error: \(error!.localizedDescription)")
                                
                                return
                            }
                            guard let url = url else {
                                return
                            }
                            
                            print("user display name changed!")
                            self.saveProfile(username: userName, profileImageURL: url) {
                                success in
                                
                                if (success != nil) {
                                    self.dismiss(animated: true, completion: nil)
                                }
                            }
                        }
                    }
                   
                    let currentUser = Auth.auth().currentUser
                    if let currentUser = currentUser {
                        // The user's ID, unique to the Firebase project.
                        // Do NOT use this value to authenticate with your backend server,
                        // if you have one. Use getTokenWithCompletion:completion: instead.
                    
                        //User was created successfully, now store the first name and last name
                        let db = Firestore.firestore()
                        var data = ["username": userName, "firstname":firstName, "lastname":lastName, "uid": user!.user.uid]
                        if let url = currentUser.photoURL?.absoluteString {
                            data["photoURL"] = url
                        }
                        
                        db.collection("users").addDocument(data: data) { (error) in
                            
                            if error != nil {
                                self.showError("User data couldn't be created")
                            }
                        }
                    }
                    //Transition to the home screen
                    self.transitionToHome()
                }
            }
        }
    }
    
    func uploadProfile(_ image: UIImage, completion: @escaping((_ url:URL?)->())) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let storageRef = Storage.storage().reference().child("user/\(uid)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            guard let metadata = metaData else {
                // Uh-oh, an error occurred!
                return
            }
                // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
                // You can also access to download URL after upload.
            storageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    // Uh-oh, an error occurred!
                        return
                }
                if let url = url {
                    print("Here is your download URL: \(url.absoluteString)")
                }
            })
        
        }
        
    }
    
    func saveProfile(username:String, profileImageURL:URL, completion: @escaping((_ success:URL?)->())) {
        
        guard (Auth.auth().currentUser?.uid) != nil else { return }
        let ref = Firestore.firestore().collection("users").document("uid")
    
        ref.setData([
                "username": username,
                "photoURL": profileImageURL.absoluteString
                ] as [String:Any]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
    }
    
    func showError(_ message: String) {
        //There's something wrong with the fields, show error message
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
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
