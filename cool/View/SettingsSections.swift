//
//  SettingsSections.swift
//  cool
//
//  Created by Nadia Leung on 1/20/20.
//  Copyright © 2020 Apple Inc. All rights reserved.
//
protocol SectionType: CustomStringConvertible {
    var constainsSwitch: Bool { get }
}

enum SettingsSection: Int, CaseIterable, CustomStringConvertible {
    case Account
    case Privacy
    
    var description: String {
        switch self {
        case .Account: return "Account"
        case .Privacy: return "Privacy & Security"
        }
    }
}

enum ProfileOptions: Int, CaseIterable, SectionType {
    case editProfile
    case delete
    case payment
    
    var constainsSwitch: Bool { return false }


    var description: String {
        switch self {
        case .editProfile: return "Edit Profile"
        case .delete: return "Delete Account"
        case .payment: return "Payment Method"

        }
    }
}

enum PrivacyOptions: Int, CaseIterable, SectionType {
    case notifications
    case email
    case report
    
    var constainsSwitch: Bool {
        switch self {
        case .notifications: return true
        case .email: return true
        case .report: return false
        }
    }
    
    var description: String {
        switch self {
        case .notifications: return "Notifications"
        case .email: return "E-Mail"
        case .report: return "Report Crashes"
        }
    }
}
