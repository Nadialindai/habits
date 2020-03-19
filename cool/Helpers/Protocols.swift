//
//  Protocols.swift
//  cool
//
//  Created by Nadia Leung on 1/18/20.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

protocol ContainerControllerDelegate {
    //toggling handled by container and not by home controller
    //present the homeview controller over the container controller
    func handleMenuToggle(forMenuOption menuOption: MenuOption?)
}


