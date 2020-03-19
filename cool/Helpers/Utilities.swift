//
//  Utilities.swift
//  customauth
//
//  Created by Christopher Ching on 2019-05-09.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit
import UIKit
import JGProgressHUD

class Service {
    static let baseColor = UIColor(r: 254, g: 202, b: 64)
    static let darkBaseColor = UIColor(r: 253, g: 166, b: 47)
    static let unselectedItemColor = UIColor(r: 173, g: 173, b: 173)
    
    static let buttonTitleFontSize: CGFloat = 16
    static let buttonTitleColor = UIColor.white
    static let buttonBackgroundColorSignInWithFacebook = UIColor(r: 88, g: 86, b: 214)
    static let buttonCornerRadius: CGFloat = 7
}

class Utilities {
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 55/255, green: 120/255, blue: 250/255, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
  
    
    static func styleFilledFBButton(_ button: UIButton) {
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: Service.buttonTitleFontSize)
        button.setTitleColor(Service.buttonTitleColor, for: .normal)
        button.backgroundColor = Service.buttonBackgroundColorSignInWithFacebook
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25.0
        button.tintColor = .white
        button.contentMode = .scaleAspectFit
        
    }
   
    
    //Video by Magda Ehlers from Pexels
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
        
    }
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
}
