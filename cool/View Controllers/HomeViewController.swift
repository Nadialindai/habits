//
//  HomeViewController.swift
//  cool
//
//  Created by Nadia Leung on 1/16/20.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class HomeViewController: UIViewController {

    //Mark: - Properties
    
    var menuController: MenuViewController!
    var centerController: UIViewController!
    
    var isExpanded = false
    //Mark: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContainerController()
       
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return isExpanded
    }
  
    // Mark: - Handlers
    
    func configureContainerController() {
        let containerController = ContainerViewController()
        containerController.delegate = self
        centerController = UINavigationController(rootViewController: containerController)
        
        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
    }
    
    func configureMenuController() {
        if menuController == nil {
            //add menu view controller
            menuController = MenuViewController()
            menuController.delegate = self
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
        }
    }
    
    
    func animatePanel(shouldExpand: Bool, menuOption: MenuOption?) {
        if shouldExpand {
            // show menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                
                self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 80
            }, completion: nil) //no completion handler her
        } else {
            // hide menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = 0
            }) { (_) in
                guard let menuOption = menuOption else {
                    return
                }
                self.didSelectMenuOption(menuOption: menuOption)
                // completion handler, after animation is clicked the link gets accessed
                
            }
            
        }
        animateStatusBar()
        
    }
    

    
    func didSelectMenuOption(menuOption: MenuOption) {
        switch menuOption {
            
        case.About:
            print("Show about")      
        case.Feed:
            let controller = FeedViewController()
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case.Stats:
            let controller = StatViewController()
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case.Settings:
            let controller = SettingsViewController() 
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case.Logout:
           handleSignout()
            
        }
    }
    
   
    @objc func handleSignout() {
        
        let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive) { (action) in
            do {
                try Auth.auth().signOut()
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let welcomeVC = storyBoard.instantiateViewController(withIdentifier: Constants.Storyboard.welcomeController) as! ViewController
                self.present(UINavigationController(rootViewController: welcomeVC), animated: true, completion: nil)
            } catch let err {
                print("Failed to sign out with error", err)
                SparkService.showAlert(style: .alert, title: "Sign Out Error", message: err.localizedDescription)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        SparkService.showAlert(style: .actionSheet, title: nil, message: nil, actions: [signOutAction, cancelAction], completion: nil)
        
        
    }

    
    func animateStatusBar() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)    }
    
}


extension HomeViewController: ContainerControllerDelegate {
    
    func handleMenuToggle(forMenuOption menuOption: MenuOption?) {
        
        if !isExpanded {
            configureMenuController()
            
        }
        isExpanded = !isExpanded
        animatePanel(shouldExpand: isExpanded, menuOption: menuOption)
    }
    
}
