//
//  Post.swift
//  cool
//
//  Created by Nadia Leung on 1/21/20.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation
import FirebaseFirestore
import UIKit

class Post {
    var image: UIImage
    var id: String
    var author:String
    var text: String
    

    init(image: UIImage, id:String, author:String, text:String) {
        self.image = image
        self.id = id
        self.author = author
        self.text = text
    }
   
}


