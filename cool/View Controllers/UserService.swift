//
//  UserService.swift
//  cool
//
//  Created by Nadia Leung on 1/21/20.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class UserService {
    
    static var currentUserProfile:SparkUser?
    
    static func observeUserProfile(_ uid: String, completion: @escaping ((_ message: String, _ error: Error?, _ userProfile:SparkUser?)->())) {
        
        Spark.Firestore_Users_Collection.document(uid)
            .addSnapshotListener { documentSnapshot, error in
                
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                let sparkProfile = SparkUser(documentData: data)
                completion("Fetched: \(String(describing: sparkProfile))", nil, sparkProfile)
                
        }

      
    }
}
    




    

