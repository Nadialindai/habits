//
//  Habit.swift
//  cool
//
//  Created by Nadia Leung on 2/20/20.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation
import UIKit

//habit object for posting
struct Habit {
    let title: String
    let photo: UIImage


    
    var dictionary: [String: Any] {
        return [
            HabitKeys.Habit.photo: photo,
            HabitKeys.Habit.title: title,
           
        ]
    }
}
