//
//  SparkSafeKeys.swift
//  TestingFirestoreAuth
//
//  Created by Alex Nagy on 28/11/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//

import Foundation

struct SparkKeys {
    
    struct SparkUser {
        static let uid = "uid"
        static let name = "name"
        static let username = "username"
        static let email = "email"
        static let profileImageUrl = "profileImageUrl"
    }
    
    struct CollectionPath {
        static let users = "users"
    }
    
    struct StorageFolder {
        static let profileImages = "profileImages"
    }
}
