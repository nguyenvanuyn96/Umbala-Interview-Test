//
//  ElevatorViewController.swift
//  Umbala-Interview-Test
//
//  Created by Nguyen Van Uy on 4/13/18.
//  Copyright © 2018 Uy Nguyen Van. All rights reserved.
//

import Foundation
import UIKit


class ElevatorTableViewCell: UITableViewCell {
    static var CELL_IDENTIFIER: String { return "ElevatorTableViewCell" }
    
    private var _containerView: UIView!
    private var _nameLabel: UILabel!
    private var _tickCountLabel: UILabel!
    private var _moveOnEachFloorProgressBar: UIView!
    private var _currentFloorLabel: UILabel!
    private var _requestPoolLabel: UILabel!
    
    private var _elevator: Elevator!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// Setup init view component.
    private func setupViews() {
        self._containerView = UIView()
        
        self._nameLabel = UILabel()
        self._nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        self._nameLabel.numberOfLines = 1
        self._nameLabel.lineBreakMode = .byTruncatingTail
        
        
        self._tickCountLabel = UILabel()
        self._tickCountLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        self._tickCountLabel.numberOfLines = 1
        self._tickCountLabel.lineBreakMode = .byTruncatingTail
        
        self._currentFloorLabel = UILabel()
        self._currentFloorLabel.font = UIFont.systemFont(ofSize: 64, weight: .medium)
        self._currentFloorLabel.numberOfLines = 1
        self._currentFloorLabel.lineBreakMode = .byTruncatingTail
        self._currentFloorLabel.textAlignment = .right
        
        self._moveOnEachFloorProgressBar = UIView()
        self._moveOnEachFloorProgressBar.backgroundColor = UIColor.red
        self._moveOnEachFloorProgressBar.frame  = self.frame
        
        self._requestPoolLabel = UILabel()
        self._requestPoolLabel.textColor = UIColor.gray
        self._requestPoolLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        self._requestPoolLabel.numberOfLines = 1
        self._requestPoolLabel.lineBreakMode = .byTruncatingHead
        
        self._containerView.addSubview(self._moveOnEachFloorProgressBar)
        self._containerView.addSubview(self._nameLabel)
        self._containerView.addSubview(self._tickCountLabel)
        self._containerView.addSubview(self._currentFloorLabel)
        self._containerView.addSubview(self._requestPoolLabel)
        
        self.addSubview(self._containerView)
    }
    
    /// Setup Layout for view component.
    private func setupLayout() {
        self._containerView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        self._nameLabel.snp.remakeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        self._tickCountLabel.snp.remakeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(100)
        }
        
        self._currentFloorLabel.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalTo(self._nameLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        //
        //        self._moveOnEachFloorProgressBar.snp.remakeConstraints { (make) in
        //            make.leading.equalToSuperview()
        //            make.trailing.equalToSuperview()
        //            make.top.equalToSuperview()
        //            make.bottom.equalToSuperview()
        //        }
        
        self._requestPoolLabel.snp.remakeConstraints { (make) in
            make.height.equalTo(30)
            make.leading.equalTo(self._nameLabel)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(0)
        }
    }
    
    func configureCell(with elevator: Elevator) {
        self._elevator = elevator
        
        self._currentFloorLabel.text = String(elevator.currentFloor)
        self._nameLabel.text = elevator.name
        self._requestPoolLabel.text = "Requested: \(elevator.movePath)"
        self._tickCountLabel.text = "WaitProgress =\(elevator.waitPercentProgress*100)%"
        
        self.updateProgressView(elevator: elevator)
        
        if elevator.isRunning {
            if elevator.isPickingUp {
                self._moveOnEachFloorProgressBar.backgroundColor = UIColor.yellow
            } else {
                self._moveOnEachFloorProgressBar.backgroundColor = UIColor.green
            }
        } else {
            self._moveOnEachFloorProgressBar.backgroundColor = UIColor.red
        }
    }
    
    private func updateProgressView(elevator: Elevator) {
        if elevator.moveDirection == .up {
            if elevator.waitPercentProgress == 0 {
                self._moveOnEachFloorProgressBar.snp.remakeConstraints { (make) in
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                    make.top.equalToSuperview().offset(Float(self._containerView.frame.height))
                    make.bottom.equalToSuperview()
                }
            } else {
                self._moveOnEachFloorProgressBar.snp.remakeConstraints { (make) in
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                    make.top.equalToSuperview().offset(Float(self._containerView.frame.height) * (1.0-elevator.waitPercentProgress))
                    make.bottom.equalToSuperview()
                }
            }
        } else if elevator.moveDirection == .down {
            
            self._moveOnEachFloorProgressBar.snp.remakeConstraints { (make) in
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.top.equalToSuperview()
                make.bottom.equalToSuperview().offset(-Float(self._containerView.frame.height) * (1.0-elevator.waitPercentProgress))
            }
        } else {
            self._moveOnEachFloorProgressBar.snp.remakeConstraints { (make) in
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        }
    }
}

class ElevatorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ElevatorDelegate {
    
    private var _decriptionInputRequestLabel: UILabel!
    private var _requestInputTextField: UITextField!
    private var _requestButton: UIButton!
    private var _elevatorTableView: UITableView!
    
    private var _numFloors: Int = 0
    private var _numElevators: Int = 0
    private var _timeMoves: Float = 0
    private var _timePickup: Float = 0
    
    private var _elevatorArr: [Elevator] = [Elevator]()
    private var _pendingRequests: [ElevatorRequest] = [ElevatorRequest]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self._numFloors = UserDefaults.standard.integer(forKey: "num_floor")
        self._numElevators = UserDefaults.standard.integer(forKey: "num_elevator")
        self._timeMoves = UserDefaults.standard.float(forKey: "time_moves_on_each_floor")
        self._timePickup = UserDefaults.standard.float(forKey: "time_pickup_on_each_floor")
        
        for i in 1...self._numElevators {
            let elevator = Elevator(name: "Elevator\(i)", numFloors: self._numFloors, maxWeight: 1000, currentWeight: 0, isRunning: false, isPickingUp: false, currentFloor: 0, timeForPickup: self._timePickup, timeForMoveEachFloor: self._timeMoves)
            
            elevator.delegate = self
            self._elevatorArr.append(elevator)
        }
    }
    
    override func viewDidLoad() {
        self.setupView()
        self.setupLayout()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(didAnElevatorFreeRequest(_:)), name: NSNotification.Name(rawValue: NotificationKey.UMBALA_ABILITY_TEST_ELEVATOR_FREE_REQUEST), object: nil)
    }
    
    private func setupView() {
        self.edgesForExtendedLayout = []
        
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.plain, target: self, action: #selector(didTapCloseBarButton))
        self.navigationController?.title = "Elevator"
        
        self._elevatorTableView = UITableView()
        self._elevatorTableView.register(ElevatorTableViewCell.self, forCellReuseIdentifier: ElevatorTableViewCell.CELL_IDENTIFIER)
        self._elevatorTableView.delegate = self
        self._elevatorTableView.dataSource = self
        
        self._decriptionInputRequestLabel = UILabel()
        self._decriptionInputRequestLabel.numberOfLines = 0
        self._decriptionInputRequestLabel.text = "Please input request as following the syntax: x,y,w. x is current floor. y is destination floor. w is the weight of passenger. If you want to add multi-request at the same time, each package data will be separated by a dot. Ex: 2,5,60.2,7,80."
        
        self._requestInputTextField = UITextField()
        self._requestInputTextField.layer.borderWidth = 2
        self._requestInputTextField.layer.borderColor = UIColor.black.cgColor
        self._requestInputTextField.keyboardType = .numbersAndPunctuation
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self._requestInputTextField.frame.height))
        self._requestInputTextField.leftView = paddingView
        self._requestInputTextField.leftViewMode = UITextFieldViewMode.always
        let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self._requestInputTextField.frame.height))
        self._requestInputTextField.rightView = paddingView1
        self._requestInputTextField.rightViewMode = UITextFieldViewMode.always
        
        self._requestInputTextField.text = "2,7,60.9,1,80.4,8,56"//"2,0,45.2,4,67"//"2,7,60.9,1,80.4,8,56"
        
        self._requestButton = UIButton()
        self._requestButton.layer.borderColor = UIColor.blue.cgColor
        self._requestButton.layer.borderWidth = 2
        self._requestButton.layer.cornerRadius = 8
        self._requestButton.setTitle("Request", for: UIControlState.normal)
        self._requestButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        self._requestButton.backgroundColor = UIColor.blue
        self._requestButton.addTarget(self, action: #selector(didTapRequestButton), for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(self._elevatorTableView)
        self.view.addSubview(self._decriptionInputRequestLabel)
        self.view.addSubview(self._requestInputTextField)
        self.view.addSubview(self._requestButton)
    }
    
    private func setupLayout() {
        self._decriptionInputRequestLabel.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        self._requestInputTextField.snp.remakeConstraints { (make) in
            make.top.equalTo(self._decriptionInputRequestLabel.snp.bottom)
            make.leading.equalTo(self._decriptionInputRequestLabel)
            make.trailing.equalTo(self._requestButton.snp.leading).offset(-10)
            make.height.equalTo(40)
        }
        
        self._requestButton.snp.remakeConstraints { (make) in
            make.top.equalTo(self._requestInputTextField)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
        
        self._elevatorTableView.snp.remakeConstraints { (make) in
            make.top.equalTo(self._requestInputTextField.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._elevatorArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ElevatorTableViewCell.CELL_IDENTIFIER) as! ElevatorTableViewCell
        if let elevator = self._elevatorArr[atIndex: indexPath.row] {
            cell.configureCell(with: elevator)
        }
        
        return cell
    }
    
    
    func needUpdateUI(elevator: Elevator) {
        if let index = self._elevatorArr.index(where: { $0.name == elevator.name }) {
            let indexPath = IndexPath(row: index, section: 0)
            
            DispatchQueue.main.async {
                self._elevatorTableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
    
    @objc private func didTapCloseBarButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapRequestButton() {
        self._requestInputTextField.resignFirstResponder()
        let requests = self.getRequests()
        
        if requests.count <= 0 {
            PopupManager.showPopup(title: "Error", message: "Please input the valid request data", completion: {
                //do nothing
            }, actionHandle: {
                //do nothing
            })
        } else {
            print("==========================================================\n===========User just has been requested a lot of requests \(String(describing: self._requestInputTextField.text))")
            
            self._pendingRequests.append(contentsOf: requests)
            
            self.checkAndAssignPendingRequests(elevators: self._elevatorArr)
        }
    }
    
    private func getRequests() -> [ElevatorRequest] {
        
        var requests = [ElevatorRequest]()
        
        if let rawInput = self._requestInputTextField.text, rawInput != "" {
            let rawRequestInputs = rawInput.split(separator: ".")
            for rawRequest in rawRequestInputs {
                let requestInfo = rawRequest.split(separator: ",")
                if requestInfo.count == 3, let source = Int(requestInfo[0]), let destination = Int(requestInfo[1]), let weight = Int(requestInfo[2])  {
                    let request = ElevatorRequest(requestId: "ElevatorRequest_\(NSUUID().uuidString)", sourceFloor: source, destinationFloor: destination, weight: weight)
                    
                    requests.append(request)
                }
            }
        }
        
        return requests
    }
    
    private func checkAndAssignPendingRequests(elevators: [Elevator]) {
        for request in self._pendingRequests {
            if let bestElevator = getElevatorBestCanServe(request: request, elevators: elevators) {
                request.isBeingServed = true
                bestElevator.addRequest(request)
                print("===========\(bestElevator.name) just has been added request (source: \(request.sourceFloor), destionation: \(request.destinationFloor))")
            } else {
                request.isBeingServed = false//Đảm bảo là request này được giữ lại ở hàng đợi
                print("===========There no elevator can't serve the request (source: \(request.sourceFloor), destionation: \(request.destinationFloor))")
            }
        }
        
        //Remove ra khỏi hàng đợi những request đã được phục vụ
        self._pendingRequests = self._pendingRequests.filter({ return !$0.isBeingServed })
        
        for elevator in self._elevatorArr {
            elevator.run()
        }
    }
    
    private func getElevatorBestCanServe(request: ElevatorRequest, elevators: [Elevator]) -> Elevator? {
        var servable = [(elevator: Elevator, length: Int)]()
        
        for elevator in elevators {
            if elevator.moveDirection == .up && request.requestDirection == .up {//Cùng hướng lên
                if elevator.currentFloor <= request.sourceFloor {//Vị trí của elevator có thấp hơn hoặc bằng vị trí đón của request hay không?
                    if (elevator.destinationFloor < request.destinationFloor && elevator.destinationFloor >= elevator.nextFloor) || (elevator.destinationFloor >= request.destinationFloor) {
                        servable.append((elevator, abs(elevator.currentFloor - request.sourceFloor)))
                    }
                }
            } else if elevator.moveDirection == .down && request.requestDirection == .down {//Cùng hướng xuống
                if request.sourceFloor <= elevator.currentFloor {//Vị trí của elevator có thấp hơn hoặc bằng vị trí đón của request hay không?
                    if (elevator.destinationFloor > request.destinationFloor && elevator.destinationFloor <= elevator.nextFloor) || (elevator.destinationFloor <= request.destinationFloor) {
                        servable.append((elevator, abs(elevator.currentFloor - request.sourceFloor)))
                    }
                }
            } else if elevator.moveDirection == .up && request.requestDirection == .down {
                if elevator.currentFloor <= request.sourceFloor {
                    if (elevator.destinationFloor <= request.destinationFloor && elevator.nextFloor >= request.sourceFloor) {
                        servable.append((elevator, abs(elevator.currentFloor - request.sourceFloor)))
                    }
                }
            } else if elevator.moveDirection == .down && request.requestDirection == .up {
                if request.sourceFloor <= elevator.currentFloor {
                    if (elevator.destinationFloor >= request.destinationFloor && elevator.nextFloor <= request.sourceFloor) {
                        servable.append((elevator, abs(elevator.currentFloor - request.sourceFloor)))
                    }
                }
            }
                
            else if elevator.moveDirection == .none {
                servable.append((elevator, abs(request.sourceFloor - elevator.currentFloor)))
            }
        }
        
        let serveElevator = servable.min(by: { return $0.length < $1.length })
        
        return serveElevator?.elevator
    }
    
    @objc private func didAnElevatorFreeRequest(_ noti: Notification) {
        if let elevator = noti.userInfo?["elevator"] as? Elevator {
            self.checkAndAssignPendingRequests(elevators: [elevator])
        }
    }
}

