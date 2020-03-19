//
//  MenuOption.swift
//  cool
//
//  Created by Nadia Leung on 1/19/20.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation
import UIKit

enum MenuOption: Int, CustomStringConvertible {
    case Stats
    case Feed
    case Settings
    case About
    case Logout
    
    
    var description: String {
        switch self {
        case .Stats: return "Stats"
        case .Feed: return "Feed"
        case .Settings: return "Settings"
        case .About: return "About"
        case .Logout: return "Logout"
        }
    }
    
    var image: UIImage {
        switch self {
        case .Stats: return UIImage(named: "logo") ?? UIImage()
        case .Feed: return UIImage(named: "icons8-rating-50") ?? UIImage()
        case .Settings: return UIImage(named: "icons8-settings-50") ?? UIImage()
        case .About: return UIImage(named: "icons8-info-50") ?? UIImage()
        case .Logout: return UIImage(named: "icons8-unavailable-50") ?? UIImage()
        }
    }
    
}
