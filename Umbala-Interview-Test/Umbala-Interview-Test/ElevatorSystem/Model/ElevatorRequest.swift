//
//  ElevatorRequest.swift
//  Umbala-Interview-Test
//
//  Created by Nguyen Van Uy on 4/13/18.
//  Copyright © 2018 Uy Nguyen Van. All rights reserved.
//

import Foundation

class ElevatorRequest {
    var requestId: String
    var sourceFloor: Int
    var destinationFloor: Int
    var weight: Int
    var isInProgress: Bool
    var isBeingServed: Bool
    
    init() {
        self.requestId = "generated"
        self.sourceFloor = 0
        self.destinationFloor = 0
        self.weight = 0
        self.isInProgress = false
        self.isBeingServed = false
    }
    
    init(requestId: String, sourceFloor: Int, destinationFloor: Int, weight: Int, isInProgress: Bool = false, isBeingServed: Bool = false) {
        self.requestId = requestId
        self.sourceFloor = sourceFloor
        self.destinationFloor = destinationFloor
        self.weight = weight
        self.isInProgress = isInProgress
        self.isBeingServed = isBeingServed
    }
    
    var requestDirection: ElevatorDirection {
        get {
            if sourceFloor == destinationFloor {
                return .none
            } else if sourceFloor > destinationFloor {
                return .down
            } else {
                return .up
            }
        }
    }
    
    func getRequestInString() -> String {
        return "[\(self.sourceFloor), \(self.destinationFloor), \(self.weight)]"
    }
}
