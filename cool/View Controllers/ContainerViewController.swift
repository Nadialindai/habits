//
//  ContainerController.swift
//  cool
//
//  Created by Nadia Leung on 1/18/20.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation
import UIKit

class ContainerViewController: UIViewController {
    //Mark: - Properties
    var delegate: ContainerControllerDelegate?
    
    //Mark: - Init
    var tableView = UITableView()
    
    //Array for habits posted
    var posts = [Habit]()
    
    struct Cells {
        static let habitCell = "HabitCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       posts = fetchData()
        view.backgroundColor = .white
        
        configureNavigationBar()
        configureTableView()
    }
    
  
    
    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
    
    @objc func addHabit() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "newPostVC") as! NewPostViewController
        self.present(nextViewController, animated:true, completion:nil)
        let navigationBar: UINavigationBar = UINavigationBar()
        self.view.addSubview(navigationBar);
        
    }
    /* https://stackoverflow.com/questions/27374759/programmatically-navigate-to-another-view-controller-scene
     */
    
    // Mark: - Handlers
    func configureNavigationBar() {
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        navigationController?.navigationBar.barStyle = .black

        navigationItem.title = "Habits"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-edit-50").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(addHabit))
    }
    
   
    func configureTableView() {
        view.addSubview(tableView)
        
        //set delegates
        setTableViewDelegates()
        tableView.rowHeight = 100
        //set row height
        //register cells
        tableView.register(HabitCell.self, forCellReuseIdentifier: Cells.habitCell)
        //set constraints
        tableView.pin(to: view)
        
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension ContainerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.habitCell) as! HabitCell
        let post = posts[indexPath.row]
        cell.set(post: post)
        
        return cell
    }
    
}

extension ContainerViewController {
    
    func fetchData() -> [Habit] {
        
      Spark.Firestore_Habits_Collection
        .addSnapshotListener { (querySnapshot, error) in
            
            var tempPosts = [Habit]()
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                for document in snapshot.documents {
                    let data = document.data()
                    let profileImageData = data["profileImageUrl"] as? String ?? ""
                    guard let imageURL = URL(string: profileImageData) else { return }
                    guard let imageData = try? Data(contentsOf: imageURL) else { return }
                    let image = UIImage(data: imageData)
                    guard (image?.jpegData(compressionQuality: 0.3)) != nil else { return }
                    let title = data["title"] as? String ?? ""
                    let newPost = Habit(title: title, photo: image!)
                   tempPosts.append(newPost)
                }
            
                DispatchQueue.main.async {
                    print("Successfully posted")
                    self.posts = tempPosts
                    self.tableView.reloadData()
                }
        }
        return posts
    }
}


