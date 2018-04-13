//
//  InstagramRelationshipType.swift
//  Umbala-Interview-Test
//
//  Created by Nguyen Van Uy on 4/13/18.
//  Copyright © 2018 Uy Nguyen Van. All rights reserved.
//

import Foundation

enum InstagramRelationshipType: String,  Codable {
    //outgoing_status: Your relationship to the user.
    case none//used for both `outgoing_status` and `incoming_status`
    case follows
    case requested
    
    //incoming_status: A user's relationship to you.
    case followedBy
    case requestedBy
    case blockedByYou
    
    enum CodingKeys: String, CodingKey
    {
        case none
        case follows
        case requested
        case followedBy = "followed_by"
        case requestedBy = "requested_by"
        case blockedByYou = "blocked_by_you"
    }
}
