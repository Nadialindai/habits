//
//  LoginViewController.swift
//  cool
//
//  Created by Nadia Leung on 1/16/20.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import JGProgressHUD
import TinyConstraints


class LoginViewController: UIViewController {
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var fbLoginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements() {
        
        errorLabel.alpha = 0
        
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
        Utilities.styleFilledFBButton(fbLoginButton)
    }

    
    @IBAction func fbLoginTapped(_ sender: Any) {
        hud.textLabel.text = "Signing in with Facebook..."
        hud.show(in: view)
        
        Spark.signInWithFacebook(in: self) { (message, err, sparkUser) in
            if let err = err {
                DispatchQueue.main.async {
                    SparkService.dismissHud(self.hud, text: "Error", detailText: "\(message) \(err.localizedDescription)", delay: 3)
                    return
                }
            }
            guard let sparkUser = sparkUser else {
                SparkService.dismissHud(self.hud, text: "Error", detailText: "Failed to fetch user", delay: 3)
                return
            }
            
            DispatchQueue.main.async {
                print("Successfully signed in with Facebook with Spark User: \(sparkUser)")
              SparkService.dismissHud(self.hud, text: "Success", detailText:  "Successfully signed in with Facebook", delay: 3)
    
                let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
                
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
     
        //TODO: Validate Text Fields
        //Validate text fields
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    
        //Signing in the User
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            } else {
                
                    let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
                    
                    self.view.window?.rootViewController = homeViewController
                    self.view.window?.makeKeyAndVisible()
              
            }
                
        }
    }
    
}
