//
//  PostTableViewCell.swift
//  cool
//
//  Created by Nadia Leung on 1/21/20.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(post:Post) {
        usernameLabel.text = post.author
        postTextLabel.text = post.text
    }
    
}
