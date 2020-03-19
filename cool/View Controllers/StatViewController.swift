//
//  UserProfileController.swift
//  FirebaseAuthentication
//
//  Created by Alex Nagy on 14/02/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//
import UIKit
import TinyConstraints
import JGProgressHUD

class StatViewController: UIViewController {
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    let profileImageViewHeight: CGFloat = 78
    lazy var profileImageView: UIImageView = {
        var iv = UIImageView()
      let currentUser = Spark.fetchCurrentSparkUser(completion: <#T##(String, Error?, SparkUser?) -> ()#>)
        iv.backgroundColor = Service.baseColor
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = profileImageViewHeight / 2
        iv.clipsToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let uidLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Profile"
        navigationController?.navigationBar.barStyle = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-edit-50").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleFetchUserButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-delete-50").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        
        setupViews()
       // fetchCurrentUser()
    }

    
    @objc func handleFetchUserButtonTapped() {
        //fetchCurrentUser()
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
  /*
    func fetchCurrentUser() {
        hud.textLabel.text = "Fetching user.."
        hud.show(in: view)
        Spark.fetchSparkUser{ (message, err, sparkUser) in
        if let err = err {
            SparkService.dismissHud(self.hud, text: "error", detailText: "(message) \(err.localizedDescription)", delay: 3)
            return
        }
        
        guard let sparkUser = sparkUser else {
             SparkService.dismissHud(self.hud, text: "error", detailText: "Failed to fetch user", delay: 3)
            return
            }
            Spark.fetchProfileImage(sparkUser: sparkUser, completion:  { (message, err, image) in
            if let err = err {
                SparkService.dismissHud(self.hud, text: "error", detailText: "(message) \(err.localizedDescription)", delay: 3)
                return
            }
            guard let image = image else {
                SparkService.dismissHud(self.hud, text: "error", detailText: "Failed to fetch image", delay: 3)
                return
                }
                
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                    self.nameLabel.text = sparkUser.name
                    self.uidLabel.text = sparkUser.uid
                    self.emailLabel.text = sparkUser.email
                    
                }
                SparkService.dismissHud(self.hud, text: "Success", detailText: "Successfully fetch image", delay: 3)
                
            })
        }
    }
    */
    
    
    fileprivate func setupViews() {
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(uidLabel)
        view.addSubview(emailLabel)
        
        profileImageView.topToSuperview(offset: 10, usingSafeArea: true)
        profileImageView.leftToSuperview(offset: 10, usingSafeArea: true)
        profileImageView.width(profileImageViewHeight)
        profileImageView.height(profileImageViewHeight)
        
        nameLabel.topToSuperview(offset: 10, usingSafeArea: true)
        nameLabel.leftToRight(of: profileImageView, offset: 10)
        nameLabel.rightToSuperview(offset: 10, usingSafeArea: true)
        
        uidLabel.topToBottom(of: nameLabel, offset: 8)
        uidLabel.leftToRight(of: profileImageView, offset: 10)
        uidLabel.rightToSuperview(offset: 10, usingSafeArea: true)
        
        emailLabel.topToBottom(of: uidLabel, offset: 4)
        emailLabel.leftToRight(of: profileImageView, offset: 10)
        emailLabel.rightToSuperview(offset: 10, usingSafeArea: true)
        
    }
    
    
}

