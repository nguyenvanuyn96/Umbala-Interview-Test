//
//  InstagramUserInfo.swift
//  Umbala-Interview-Test
//
//  Created by Nguyen Van Uy on 4/13/18.
//  Copyright © 2018 Uy Nguyen Van. All rights reserved.
//

import Foundation

class InstagramUserInfo: Codable {
    var fullName: String
    var profilePictureUrl: String
    var username: String
    var id: String
    var isFollowing: Bool = true//This property to help determire when it is unfollowed
    
    init(fullName: String, profilePictureUrl: String, username: String, id: String, isFollowing: Bool = true) {
        self.fullName = fullName
        self.profilePictureUrl = profilePictureUrl
        self.username = username
        self.id = id
        self.isFollowing = isFollowing
    }
    
    enum CodingKeys: String, CodingKey
    {
        case fullName = "full_name"
        case profilePictureUrl = "profile_picture"
        case username
        case id
    }
}
