//
//  Post.swift
//  cool
//
//  Created by Nadia Leung on 1/21/20.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol DocumentSerial {
    init?(documentData: [String: Any])
}

class Post {
    var image:URL
    var name:String
    var title:String
    var description:String
    var frequency: Int
    var timeStamp:Date
    
    var dictionary:[String:Any] {
        return [
            "name": name,
            "image": image,
            "title": title,
            "description:": description,
            "frequency": frequency,
            "timeStamp": timeStamp
        ]
    }
    
  init(image: URL, name: String, title:String, description:String, frequency: Int, timeStamp: Date) {
        self.image = image
        self.name = name
        self.title = title
        self.description = description
        self.frequency = frequency
        self.timeStamp = timeStamp
    }
   
}

extension Post: DocumentSerial {
    init?(documentData: [String : Any]) {
        guard
            let uid = documentData[SparkKeys.SparkUser.uid] as? String,
            let name = documentData[SparkKeys.SparkUser.name] as? String,
            let email = documentData[SparkKeys.SparkUser.email] as? String,
            let profileImageUrl = documentData[SparkKeys.SparkUser.profileImageUrl] as? String
            else { return nil }
        self.init(uid: uid,
                  name: name,
                  email: email,
                  profileImageUrl: profileImageUrl)
    }
}
