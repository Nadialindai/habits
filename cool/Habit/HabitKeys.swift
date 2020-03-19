//
//  HabitKeys.swift
//  cool
//
//  Created by Nadia Leung on 2/20/20.
//  Copyright © 2020 Apple Inc. All rights reserved.
//
import Foundation

struct HabitKeys {
    
    struct Habit {
        static let title = "title"
        static let description = "description"
        static let photo = "photo"
        static let trigger = "trigger"
        static let habitURL = "habitURL"
        static let frequency = "frequency"
        static let timeStamp = "timestamp"
        static let id = "id"
    }
    
    struct CollectionPath {
        static let habits = "habits"
    }
    
    struct StorageFolder {
        static let habitImages = "habitImages"
    }
}
