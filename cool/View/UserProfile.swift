//
//  UserProfile.swift
//  cool
//
//  Created by Nadia Leung on 1/21/20.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation

public struct UserProfile: Codable {
    let username: String
    let photoURL: String?
    let usercount: Int?
    let uid: String?
    
    enum CodingKeys: String, CodingKey  {
        case username
        case photoURL
        case usercount
        case uid
        
    }
}
