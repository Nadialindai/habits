//
//  ViewController.swift
//  cool
//
//  Created by Nadia Leung on 1/16/20.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import UIKit
import AVKit
import FirebaseAuth
import Firebase

class ViewController: UIViewController {

    var videoPlayer:AVPlayer? //optional to create object and intialize it later
    
    var videoPlayerLayer:AVPlayerLayer? //manages player's visual output- what user sees
    
    var handler: AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpVideo()
        
        // Do any additional setup after loading the view.
        // Set up video in the background
      
        handler = Auth.auth().addStateDidChangeListener({ (auth, user) in
            DispatchQueue.main.async {
                if Auth.auth().currentUser != nil {
                    UserService.observeUserProfile(user!.uid, completion: { (String, error, userProfile) in
                        UserService.currentUserProfile = userProfile
                    })
                }
            }
            
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let handler = handler else { return }
        Auth.auth().removeStateDidChangeListener(handler)
    }
    
   
    
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
    
    
    func setUpElements() {
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
    }
    
    func configureNavigationBar() {
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        navigationController?.navigationBar.barStyle = .black
    }
    
    func setUpVideo() {
      
        //Get path to resource in the bundle
        let bundlePath = Bundle.main.path(forResource: "loginbg", ofType: "mp4")
        
        guard bundlePath != nil else {
            return
        }
        
        //Create a URL
        let url = URL(fileURLWithPath: bundlePath!)
        
        // Create the video player item
        let item = AVPlayerItem(url: url)
        
        //Create the player
        videoPlayer = AVPlayer(playerItem: item)
        
        // Create the layer
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        
        
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*1.5, y: 0, width:
            self.view.frame.size.width*4, height:
            self.view.frame.size.height)
        
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        videoPlayer?.playImmediately(atRate: 0.3)
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.videoPlayer?.currentItem, queue: .main) { [weak self] _ in
            self?.videoPlayer?.seek(to: CMTime.zero)
            self?.videoPlayer?.play()
        }
        
    }
    
    

}

