//
//  Spark.swift
//  TestingFirestoreAuth
//
//  Created by Alex Nagy on 28/11/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//

import Firebase
import FirebaseAuth
import JGProgressHUD
import SwiftyJSON
import FirebaseStorage
import FBSDKCoreKit
import FacebookLogin
import FacebookCore
import Foundation

class Spark {
    static func start() {
        FirebaseApp.configure()
    }

    // MARK: -
    // MARK: Firestore Database
    static var firestoreSetup: Firestore = {
        let db = Firestore.firestore()
        let settings = db.settings
        db.settings = settings
        return db
    }()
    
    // MARK: -
    // MARK: Firestore Logout
    static func logout(completion: @escaping (_ result: Bool, _ error: Error?) ->()) {
       let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            completion(true, nil)
        } catch let signOutError as NSError {
            completion(false, signOutError)
        }
    }
    
    // MARK: -
    // MARK: Sign in with Facebook
    static func signInWithFacebook(in viewController: UIViewController, completion: @escaping (_ message: String, _ error: Error?, _ sparkUser: SparkUser?) ->()) {
        
        let loginManager = LoginManager() //????
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: viewController) { (result) in
            switch result {
            case .success:
                print("Succesfully logged in into Facebook.")
                self.signIntoFirebaseWithFacebook(completion: completion)
            case .failed(let err):
                completion("Failed to get Facebook user with error:", err, nil)
            case .cancelled:
                completion("Login attempt was cancelled.", nil, nil)
            }
        }
    }
    
    // MARK: -
    // MARK: Fileprivate functions
    fileprivate static func signIntoFirebaseWithFacebook(completion: @escaping (_ message: String, _ error: Error?, _ sparkUser: SparkUser?) ->()) {
        guard let tokenString = AccessToken.current?.tokenString else {
            completion("Could not fetch authenticationToken", nil, nil)
            return
        }
        let facebookCredential = FacebookAuthProvider.credential(withAccessToken: tokenString)
        signIntoFirebase(withFacebookCredential: facebookCredential, completion: completion)
    }
    
    
    fileprivate static func signIntoFirebase(withFacebookCredential facebookCredential: AuthCredential, completion: @escaping (_ message: String, _ error: Error?, _ sparkUser: SparkUser?) ->()) {
        Auth.auth().signIn(with: facebookCredential) { (result, err) in
            if let err = err { completion("Failed to sign up with error:", err, nil); return }
            print("Succesfully authenticated with Firebase.")
            self.fetchFacebookUser(completion: completion)
        }
    }
    
    fileprivate static func fetchFacebookUser(completion: @escaping (_ message: String, _ error: Error?, _ sparkUser: SparkUser?) ->()) {
    
          GraphRequest(graphPath: "me", parameters: ["fields": "id, email, first_name, last_name, picture.type(large)"], tokenString: AccessToken.current?.tokenString, version: Settings.defaultGraphAPIVersion, httpMethod: HTTPMethod.get).start(completionHandler: { (connection, result, error) -> Void in
            
            if let error = error {
                completion("Failed to fetch user.", error, nil);
                return
            }
            guard let responseDict = result as? [String:Any] else {
                completion("Failed to fetch user.", error, nil);
                return
            }
            
            guard let firstName = responseDict["first_name"] as? String,
                let lastName = responseDict["last_name"] as? String,
                let email = responseDict["email"] as? String,
                let picture = responseDict["picture"] as? [String: Any],
                let data = picture["data"] as? [String: Any],
                let profileImageFacebookUrl = data["url"] as? String else {
                completion("Failed to fetch data from responseDict json.", nil, nil); return
            }
            
            let name = "\(firstName) \(lastName)"
            let documentData = [SparkKeys.SparkUser.uid: uid!,
                                SparkKeys.SparkUser.name: name,
                                SparkKeys.SparkUser.email: email,
                                SparkKeys.SparkUser.profileImageUrl: profileImageFacebookUrl /* remember to change this to the Firebase Storage url later on*/] as [String : Any]
                
            let sparkUser = SparkUser(documentData: documentData)
            saveUserIntoFirestore(profileImageData: profileImageFacebookUrl, sparkUser: sparkUser, completion: completion)
        })
    }

    fileprivate static func saveUserIntoFirestore(profileImageData: String, sparkUser: SparkUser?, completion: @escaping (_ message: String, _ error: Error?, _ sparkUser: SparkUser?) ->()) {
    
        guard let sparkUser = sparkUser else {
            completion("Failed to fetch sparkUser", nil, nil);
            return
        }
    
        fetchSparkUser(sparkUser.uid) { (message, err, fetchedSparkUser) in
        if let err = err {
            completion("Failed to fetch user data", err, nil)
            return
        }
        
        guard let fetchedSparkUser = fetchedSparkUser else {
            saveSparkUser(profileImageData: profileImageData, sparkUser: sparkUser, completion: completion)
            return
        }
        
        deleteAsset(fromUrl: fetchedSparkUser.profileImageUrl, completion: { (result, err) in
            if let err = err {
                completion("Failed to deleted profile image form Storage", err, nil)
                return
            }
            
            if result {
                
                saveSparkUser(profileImageData: profileImageData, sparkUser: sparkUser, completion: completion)
                
            } else {
                completion("Failed to delete profile image from Storage", err, nil)
            }
        })
    }
    
}

    fileprivate static func saveSparkUser(profileImageData: String, sparkUser: SparkUser, completion: @escaping (_ message: String, _ error: Error?, _ sparkUser: SparkUser?) ->()) {
        guard let imageURL = URL(string: profileImageData) else { return }
        guard let imageData = try? Data(contentsOf: imageURL) else { return }
        let image = UIImage(data: imageData)
        guard let profileImageUploadData = image?.jpegData(compressionQuality: 0.3) else { completion("Failed to compress jpeg data", nil, nil); return }
       
        let fileName = UUID().uuidString
        let storageRef = Storage_Profile_Images.child("user/\(fileName)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        storageRef.putData(profileImageUploadData, metadata: metadata) { (metadata, error) in
            if let error = error {
                    completion("Failed to save profile image to Storage with error:", error, nil);
                return
            }
            // Metadata contains file metadata such as size, content-type.
            
            storageRef.downloadURL(completion: { (profileImageFirebaseUrl, error) in
                if let error = error {
                    completion("Failed to get download url with error:", error, nil);
                    return
                }
               
                
                guard let profileImageFirebaseUrl = profileImageFirebaseUrl else {
                    completion("Failed to get profileImageUrl.", nil, nil);
                    return
                }
                print("Successfully uploaded profile image into Firebase storage with URL:", profileImageFirebaseUrl.absoluteString)
                
                let documentPath = sparkUser.uid
                let documentData = [SparkKeys.SparkUser.uid: sparkUser.uid,
                                    SparkKeys.SparkUser.name: sparkUser.name,
                                    SparkKeys.SparkUser.email: sparkUser.email,
                                    SparkKeys.SparkUser.profileImageUrl: profileImageFirebaseUrl.absoluteString] as [String : Any]
                
                Spark.Firestore_Users_Collection.document(documentPath).setData(documentData, completion: { (err) in
                    if let err = err { completion("Failed to save document with error:", err, nil); return }
                    let newSparkUser = SparkUser(documentData: documentData)
                    print("Successfully saved user info into Firestore: \(String(describing: newSparkUser))")
                    completion("Successfully signed in with Facebook.", nil, newSparkUser)
                })
            })
    }
        
}

// MARK: -
// MARK: Fetch Profile Image
static func fetchProfileImage(sparkUser: SparkUser, completion: @escaping (_ message: String, _ error: Error?, _ image: UIImage?) ->()) {
    let profileImageUrl = sparkUser.profileImageUrl
    guard let url = URL(string: profileImageUrl) else { completion("Failed to create url for profile image.", nil, nil); return }
    
    URLSession.shared.dataTask(with: url) { (data, response, err) in
        if err != nil { completion("Failed to fetch profile image with url:", err, nil); return }
        guard let data = data else { completion("Failed to fetch profile image data", nil, nil); return }
        let profileImage = UIImage(data: data)
        completion("Successfully fetched profile image", nil, profileImage)
        }.resume()
}

// MARK: -
// MARK: Fetch Current Spark User
static func fetchCurrentSparkUser(completion: @escaping (_ message: String, _ error: Error?, _ sparkUser: SparkUser?) ->()) {
    if Auth.auth().currentUser != nil {
        guard let uid = Auth.auth().currentUser?.uid else { completion("Failed to fetch user uid.", nil, nil); return }
        fetchSparkUser(uid, completion: completion)
    }
}

// MARK: -
// MARK: Fetch Spark User with uid
static func fetchSparkUser(_ uid: String, completion: @escaping (_ message: String, _ error: Error?, _ sparkUser: SparkUser?) ->()) {
    Firestore_Users_Collection.whereField(SparkKeys.SparkUser.uid, isEqualTo: uid)
        .getDocuments { snapshot, err in
            if let err = err {
                completion("Failed to fetch docuemnt with error:", err, nil);
                return
            }
            for document in snapshot!.documents {
                print("\(document.documentID) => \(document.data())")
            }
        let sparkUser = snapshot!.documents.compactMap({
            SparkUser(documentData: $0.data())}).first
        completion("Successfully fetched spark user", nil, sparkUser)

    }
}



// MARK: -
// MARK: Delete Asset
static func deleteAsset(fromUrl url: String, completion: @escaping (_ result: Bool, _ error: Error?) ->()) {
    Storage.storage().reference(forURL: url).getMetadata { (metadata, err) in
        if let err = err, let errorCode = StorageErrorCode(rawValue: err._code) {
            if errorCode == .objectNotFound {
                print("Asset not found, no need to delete")
                completion(true, nil)
                return
            }
        }
        
        Storage.storage().reference(forURL: url).delete { (err) in
            if let err = err {
                print("Could not delete asset at url:", url)
                completion(false, err)
                return
            }
            print("Successfully deleted asset from url:", url)
            completion(true, nil)
        }
        
    }
    
}

}
