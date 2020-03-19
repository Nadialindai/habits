//
//  SparkSetup.swift
//  TestingFirestoreAuth
//
//  Created by Alex Nagy on 28/11/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//

import Firebase

extension FB {
    static let Firestore_Users_Collection = Firestore.firestore().collection("users")
    static let uid = Auth.auth().currentUser?.uid
    static let Storage_Profile_Images = Storage.storage().reference().child("user/\(String(describing: uid))")
}
