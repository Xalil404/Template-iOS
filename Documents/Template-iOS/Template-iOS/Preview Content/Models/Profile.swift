//
//  Profile.swift
//  Template-iOS
//
//  Created by TEST on 13.12.2024.
//


import Foundation

struct Account: Identifiable, Codable {
    var id: Int
    var username: String
    var bio: String?
    var profile_picture: String?
    
    // Initialization
    init(id: Int, username: String, bio: String? = nil, profile_picture: String? = nil) {
        self.id = id
        self.username = username
        self.bio = bio
        self.profile_picture = profile_picture
    }
    
}