//
//  SearchViewController.swift
//  cool
//
//  Created by Nadia Leung on 2/15/20.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation

import UIKit
import Firebase

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Properties
    
    var tableView: UITableView!
    
    var posts = [
        Post(image: #imageLiteral(resourceName: "boy"), id: "1", author: "Kim Jung Un", text: "I Like Potatoes"),
        Post(image: #imageLiteral(resourceName: "barbie"), id: "2", author: "Barbie", text: "Oh No! Potatoes are Fattening")
    ]
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = UIColor.white
        
        let cellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "postCell")
        view.addSubview(tableView)
        
        
        var layoutGuide:UILayoutGuide!
        
        layoutGuide = view.safeAreaLayoutGuide
        
        tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.reloadData() //reviews data below
    }
    
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func configureNavigationBar() {
        
        //view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Feed"
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-delete-50").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
    }
    
    
    
    @IBAction func handleLogout(_ sender:Any) {
        try! Auth.auth().signOut()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        
        cell.set(post:posts[indexPath.row])
        return cell
    }
    
}
