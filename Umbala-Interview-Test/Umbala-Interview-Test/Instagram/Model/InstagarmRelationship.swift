//
//  InstagarmRelationship.swift
//  Umbala-Interview-Test
//
//  Created by Nguyen Van Uy on 4/13/18.
//  Copyright © 2018 Uy Nguyen Van. All rights reserved.
//

import Foundation

class InstagramRelationship: Codable {
    var outgoingStatus: InstagramRelationshipType? = nil
    var incomingStatus: InstagramRelationshipType? = nil
    
    init() {
        self.outgoingStatus = InstagramRelationshipType.none
        self.incomingStatus = InstagramRelationshipType.none
    }
    
    init(outgoingStatus: InstagramRelationshipType, incomingStatus: InstagramRelationshipType) {
        self.incomingStatus = incomingStatus
        self.outgoingStatus = outgoingStatus
    }
    
    enum CodingKeys: String, CodingKey
    {
        case outgoingStatus = "outgoing_status"
        case incomingStatus = "incoming_status"
    }
}
