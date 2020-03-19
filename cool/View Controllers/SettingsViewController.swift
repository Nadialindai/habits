//
//  SettingsViewController.swift
//  cool
//
//  Created by Nadia Leung on 1/20/20.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation
import UIKit

private let reuseIdentifier = "SettingsCell"

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    var tableView: UITableView!
    var userInfoHeader: UserInfoHeader!
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helper Functions
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        tableView.frame = view.frame
        
        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 100)
        userInfoHeader = UserInfoHeader(frame: frame)
        tableView.tableHeaderView = userInfoHeader
        tableView.tableFooterView = UIView()
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func configureUI() {
        configureTableView()
        
        //view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Settings"
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-delete-50").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = SettingsSection(rawValue: section) else {
            return 0
        }
            switch section {
            case .Account: return ProfileOptions.allCases.count
            case .Privacy: return PrivacyOptions.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        
        print("Section is\(section)")
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .white
        title.text = SettingsSection(rawValue: section)?.description
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
        guard let section = SettingsSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .Account:
            let social = ProfileOptions(rawValue: indexPath.row)
            cell.sectionType = social
        case .Privacy:
            let privacy = PrivacyOptions(rawValue: indexPath.row)
            cell.textLabel?.text = privacy?.description
            cell.sectionType = privacy
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .Account:
            print(ProfileOptions(rawValue: indexPath.row)?.description)
        case .Privacy:
            print(PrivacyOptions(rawValue: indexPath.row)?.description)
            
        }
    }
    
}
