//
//  NewPostViewController.swift
//  cool
//
//  Created by Nadia Leung on 1/21/20.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseCore


class NewPostViewController:UIViewController {
    
    var db: Firestore!
    //document ID
    var ref: DocumentReference? = nil

    @IBOutlet weak var addPhoto: UIButton!
    @IBOutlet weak var imageViewField: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var triggerTextField: UITextField!
    
    @IBOutlet weak var label: UILabel!
    
    var imagePicker:UIImagePickerController!
    
    @IBAction func counter(_ sender: UIStepper) {
        label.text = String(Int(sender.value)).description
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        //Setup
        
        db = Firestore.firestore()
        
        self.configureNavBar()
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker(_:)))
        imageViewField.isUserInteractionEnabled = true
        imageViewField.addGestureRecognizer(imageTap)
        imageViewField.clipsToBounds = true
        addPhoto.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate

        Utilities.styleTextField(titleTextField)
        Utilities.styleTextField(descriptionTextField)
        Utilities.styleTextField(triggerTextField)
        
    }
    
    @objc func openImagePicker(_ sender: Any) {
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func keyboardWillShow(_ notification: NSNotification) {
        print(notification)
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            
        }
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func configureNavBar() {
        let height: CGFloat = 75
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height))
        navbar.delegate = self as? UINavigationBarDelegate
        
        let navItem = UINavigationItem()
        navbar.barTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        navbar.prefersLargeTitles = true
        navigationItem.title = "New Habit"
        navbar.barStyle = .black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-delete-50").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        
        navbar.items = [navItem]
        
        view.addSubview(navbar)
        
        self.view?.frame = CGRect(x: 0, y: height, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height - height))
        
    }
    
    func uploadPhoto(_ image: UIImage, completion: @escaping((_ url:URL?)->())) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let storageRef = Storage.storage().reference().child("habits/\(uid)")
        
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
    
    @IBAction func addPhoto(_ sender: Any) {
        guard let image = imageViewField.image else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let habitTitle = titleTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            //1. Upload the profile image to firebase storage
            self.uploadPhoto(image) { url in
               
            let currentUser = Auth.auth().currentUser
            if let currentUser = currentUser {
                // The user's ID, unique to the Firebase project.
                // Do NOT use this value to authenticate with your backend server,
                // if you have one. Use getTokenWithCompletion:completion: instead.
                
                //User was created successfully, now store the first name and last name
                let db = Firestore.firestore()
                var data = ["habit": habitTitle, "uid": uid]
                if let url = currentUser.photoURL?.absoluteString {
                    data["photoURL"] = url
                }
                
                db.collection("users").addDocument(data: data) { (error) in
                    
                    if error != nil {
                        print("Habit data couldn't be created")
                    }
                }
            }
        }
    }


    
    
    //set timestamp
    private func dataTypes() {
            // [START data_types]
            let docData: [String: Any] = [
                "stringExample": "Hello world!",
                "booleanExample": true,
                "numberExample": 3.14159265,
                "dateExample": Timestamp(date: Date()),
                "arrayExample": [5, true, "hello"],
                "nullExample": NSNull(),
                "objectExample": [
                    "a": 5,
                    "b": [
                        "nested": "foo"
                    ]
                ]
            ]
            db.collection("habits").document().setData(docData) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            // [END data_types]
    }
    
    
    @IBAction func done(_ sender: UIButton) {
        //Cloud Firestore auto-generate an ID for you. You can do this by calling add():
        //JuST STOP lOOkInG FOR LoVE GiRl YoU STiLL GOt TiME//
        //YoU PlAY YoUR RoLE ANd I'LL PlAy MinE

        Spark.fetchCurrentSparkUser(completion: { (message, error, currentUser) in
            self.saveHabit(sparkUser: currentUser, completion: ("Successfully saved habit", nil, currentUser))
                    return
        })
    }

    

    func saveHabit(sparkUser: SparkUser?, completion: (String, Error?, SparkUser?)) {
       
        guard let sparkUser = sparkUser else {
            print("Cannot find user")
            return
        }
        

        var ref: DocumentReference? = nil
       
        ref = Spark.Firestore_Habits_Collection.addDocument(data: [
            "user": [
                "user id": sparkUser.uid,
                "name": sparkUser.name,
                "profilephoto": sparkUser.profileImageUrl
            ],
            "title": titleTextField.text!,
            "description": descriptionTextField.text!,
            "trigger": triggerTextField.text!,
            "date": Timestamp(date: Date()),
            "frequency" : label.text!,
            ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
}


extension NewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.imageViewField.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}

