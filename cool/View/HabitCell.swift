//
//  HabitCell.swift
//  cool
//
//  Created by Nadia Leung on 2/6/20.
//  Copyright © 2020 Apple Inc. All rights reserved.
//
import UIKit
import Foundation

class HabitCell: UITableViewCell {
    //initialize types for labels and images
    var photoView = UIImageView()
    var titleLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(photoView)
        addSubview(titleLabel)
        
        configureImageView()
        configureTitleLabel()
        
        setImageConstraints()
        setTitleLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //imagei view settings
    func configureImageView() {
        photoView.layer.cornerRadius = 10
        photoView.clipsToBounds      = true
    }
    
    //POST NEEDS UPDATE --->>
    //configure habit cell
    func set(post: Habit) {
        photoView.image = post.photo
        titleLabel.text = post.title
    }
    
    //configure title
    func configureTitleLabel() {
        titleLabel.numberOfLines             = 0
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    //image constraints
    func setImageConstraints() {
        photoView.translatesAutoresizingMaskIntoConstraints                 = false
        photoView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        photoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        photoView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        photoView.widthAnchor.constraint(equalTo: photoView.heightAnchor, multiplier: 16/9).isActive = true
        
    }
    
    func setTitleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: 20).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }
    
}
