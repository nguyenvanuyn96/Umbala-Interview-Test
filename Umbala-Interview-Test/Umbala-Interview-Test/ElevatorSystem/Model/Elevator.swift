//
//  Elevator.swift
//  Umbala-Interview-Test
//
//  Created by Nguyen Van Uy on 4/13/18.
//  Copyright © 2018 Uy Nguyen Van. All rights reserved.
//

import Foundation

enum ElevatorDirection {
    case up
    case down
    case none
}

protocol ElevatorDelegate: class {
    func needUpdateUI(elevator: Elevator)
}

class Elevator {
    var name: String
    var maxWeight: Int
    var currentWeight: Int
    var isRunning: Bool {//still true when picking up the passenger (pickingUp = true)
        didSet {
            if !self.isRunning {
                self.isPickingUp = false
                self.nextFloor = self.currentFloor
            }
        }
    }
    var isPickingUp: Bool
    var currentFloor: Int
    var nextFloor: Int
    var destinationFloor: Int
    private var _previousMoveDirection: ElevatorDirection = .none
    
    var moveDirection: ElevatorDirection {
        get {
            var direction = ElevatorDirection.none
            
            if currentFloor < nextFloor && !self.isPickingUp {
                direction = .up
            } else if currentFloor > nextFloor && !self.isPickingUp {
                direction = .down
            } else if self.isRunning {
                direction = self._previousMoveDirection
            }
            
            self._previousMoveDirection = direction
            
            return direction
        }
    }
    var movePath: String {
        get {
            var requests = ""
            for request in self._requestPool {
                requests.append("\(request.getRequestInString()) ")
            }
            
            return requests
        }
    }
    
    private var _requestPool: [ElevatorRequest]
    
    var requestPool: [ElevatorRequest] {
        get {
            return self._requestPool
        }
    }
    
    var delegate: ElevatorDelegate?
    
    private var _timer: Timer
    var _timerTickCount: Float
    
    var waitPercentProgress: Float {
        get {
            var progress: Float = 1.0
            if isPickingUp {
                progress = self._timerTickCount / self._timeForPickup
            } else if isRunning {
                progress = self._timerTickCount / self._timeForMoveEachFloor
            }
            
            return progress
        }
    }
    
    private var _numOfFloors: Int
    private var _timeForPickup: Float
    private var _timeForMoveEachFloor: Float
    
    init() {
        self.name = "Elevator"
        self.maxWeight = 0
        self.currentWeight = 0
        self.isRunning = false
        self.isPickingUp = false
        self.currentFloor = 0
        self.nextFloor = self.currentFloor
        self.destinationFloor = self.currentFloor
        self._requestPool = [ElevatorRequest]()
        self._timer = Timer()
        self._timerTickCount = -1
        
        self._timeForPickup = 0
        self._timeForMoveEachFloor = 0
        self._numOfFloors = 0
    }
    
    init(name: String, numFloors: Int, maxWeight: Int, currentWeight: Int, isRunning: Bool, isPickingUp: Bool, currentFloor: Int, nextFloor: Int = 0, destinationFloor: Int = 0, requestPool: [ElevatorRequest] = [ElevatorRequest](), timeForPickup: Float = 3.0, timeForMoveEachFloor: Float = 5.0) {
        self.name = name
        self.maxWeight = maxWeight
        self.currentWeight = currentWeight
        self.isRunning = isRunning
        self.isPickingUp = isPickingUp
        self.currentFloor = currentFloor
        self.nextFloor = nextFloor
        self.destinationFloor = destinationFloor
        
        self._requestPool = [ElevatorRequest]()
        self._timer = Timer()
        self._timerTickCount = -1
        
        self._timeForPickup = timeForPickup
        self._timeForMoveEachFloor = timeForMoveEachFloor
        self._numOfFloors = numFloors
        
        for request in requestPool {
            self.addRequest(request)
        }
    }
    
    func addRequest(_ request: ElevatorRequest) {
        self._requestPool.append(request)
        
        //Nếu thang máy đang đứng yên thì lấy hướng của request đầu tiên làm hướng của thang máy
        if self.moveDirection == .none {
            self.nextFloor = request.sourceFloor
            self.destinationFloor = request.destinationFloor
        } else if self.moveDirection == .up && self.destinationFloor < request.destinationFloor {
            self.destinationFloor = request.destinationFloor
        } else if self.moveDirection == .down && self.destinationFloor > request.destinationFloor {
            self.destinationFloor = request.destinationFloor
        }
    }
    
    func completedARequest(requestId: String) {
        self._requestPool = self.requestPool.filter { return $0.requestId != requestId }
    }
    
    func run() {
        if !self.isRunning && self.requestPool.count > 0 {
            DispatchQueue(label: "umbala_ability_test_concurrent_\(self.name)", attributes: .concurrent).async {
                self.isRunning = true
                
                self.excute()
                
                DispatchQueue.main.async {
                    self._timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                        self.excute()
                    })
                }
            }
        }
    }
    
    @objc private func excute() {
        if self.requestPool.count == 0 && !self.isPickingUp {
            print("===========\(self.name) free request")
            self.isRunning = false
            self._timerTickCount = -1
            self._timer.invalidate()
            print("===========\(self.name) reset tickCount.")
            NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationKey.UMBALA_ABILITY_TEST_ELEVATOR_FREE_REQUEST), object: nil, userInfo: ["elevator": self])
        } else {
            let nextPickupFloorAndRequests = self.findNextPickupFloor(of: self, numOfFloor: self._numOfFloors)
            self.nextFloor = nextPickupFloorAndRequests.nextFloor
            print("===========\(self.name) has next pickup floor: \(nextPickupFloorAndRequests.nextFloor)")
            
            if self.currentFloor == nextPickupFloorAndRequests.nextFloor && !self.isPickingUp {
                //wait for pick up passenger
                self.isPickingUp = true
                
                print("===========\(self.name) reset tickCount.")
                print("===========\(self.name) pickup at \(self.currentFloor)")
                
                for requestMatched in nextPickupFloorAndRequests.requestMatcheds {
                    if requestMatched.isInProgress {
                        print("===========\(self.name) has request (source: \(requestMatched.sourceFloor), destination: \(requestMatched.destinationFloor)) done")
                        self.completedARequest(requestId: requestMatched.requestId)//Trả khách
                    } else {
                        self._requestPool = self.requestPool.map({ (request) -> ElevatorRequest in
                            if request.requestId == requestMatched.requestId {
                                request.isInProgress = true//Nhận khách
                                
                                print("===========\(self.name) has request (source: \(request.sourceFloor), destination: \(request.destinationFloor)) isInProgress")
                            }
                            return request
                        })
                    }
                }
                print("===========\(self.name) requests remain \(self.requestPool.count)")
                
            } else if isPickingUp {
                if self._timerTickCount == self._timeForPickup {//completed pickup
                    self._timerTickCount = -1//reset
                    self.isPickingUp = false
                }
            } else {
                //moving
                if self._timerTickCount == self._timeForMoveEachFloor {
                    self._timerTickCount = -1//reset
                    print("===========\(self.name) reset tickCount.")
                    self.currentFloor += (self.currentFloor < nextPickupFloorAndRequests.nextFloor) ? 1 : -1
                }
            }
            
            self._timerTickCount += 1
            print("===========\(self.name) has tickCount = \(self._timerTickCount).")
            print("===========\(self.name) has current floor: \(self.currentFloor)")
        }
        
        self.delegate?.needUpdateUI(elevator: self)
    }
    
    private func findNextPickupFloor(of elevator: Elevator, numOfFloor: Int) -> (nextFloor: Int, requestMatcheds: [ElevatorRequest]) {
        var nearestFloor = 0
        var requestMatcheds: [ElevatorRequest] = [ElevatorRequest]()
        
        switch elevator.moveDirection {
        case .up:
            nearestFloor = numOfFloor
            for request in elevator.requestPool {
                if request.isInProgress {
                    if nearestFloor > request.destinationFloor {
                        nearestFloor = request.destinationFloor
                    }
                } else if nearestFloor >= request.sourceFloor {
                    nearestFloor = request.sourceFloor
                }
            }
        case .down:
            for request in elevator.requestPool {
                if request.isInProgress {
                    if nearestFloor < request.destinationFloor {
                        nearestFloor = request.destinationFloor
                    }
                } else if nearestFloor <= request.sourceFloor {
                    nearestFloor = request.sourceFloor
                }
            }
        case .none:
            
            break
        }
        
        for request in elevator.requestPool {
            if nearestFloor == request.sourceFloor || nearestFloor == request.destinationFloor {
                requestMatcheds.append(request)
            }
        }
        
        return (nearestFloor, requestMatcheds)
    }
    
}
