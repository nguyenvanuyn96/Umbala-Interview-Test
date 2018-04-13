//
//  SetupElevatorViewController.swift
//  Umbala-Interview-Test
//
//  Created by Nguyen Van Uy on 4/13/18.
//  Copyright © 2018 Uy Nguyen Van. All rights reserved.
//

import Foundation
import UIKit

class SetupElevatorViewController: UIViewController, UITextFieldDelegate {
    
    private var _elevatorImageView: UIImageView!
    private var _decriptionInputNumFloorLabel: UILabel!
    private var _numOfFloorInputTextField: UITextField!
    private var _decriptionInputNumElevatorLabel: UILabel!
    private var _numOfElevatorInputTextField: UITextField!
    private var _decriptionInputTimeLabel: UILabel!
    private var _timeMoveInputTextField: UITextField!
    private var _decriptionInputTimePickupLabel: UILabel!
    private var _timePickupInputTextField: UITextField!
    private var _playButton: UIButton!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        self.setupView()
        self.setupLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func setupView() {
        self.edgesForExtendedLayout = []
        
        self.view.backgroundColor = UIColor.white
        
        self._elevatorImageView = UIImageView(image: UIImage(named: "elevator_cartoon"))
        self._elevatorImageView.contentMode = .scaleAspectFit
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(didTapBackBarButton))
        self.navigationController?.title = "Matrix Rotation"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        
        self._decriptionInputNumFloorLabel = UILabel()
        self._decriptionInputNumFloorLabel.text = "Number of floor"
        
        self._decriptionInputNumElevatorLabel = UILabel()
        self._decriptionInputNumElevatorLabel.text = "Number of elevator"
        
        self._decriptionInputTimeLabel = UILabel()
        self._decriptionInputTimeLabel.text = "Time moves on each floor"
        
        self._decriptionInputTimePickupLabel = UILabel()
        self._decriptionInputTimePickupLabel.text = "Time pickup on each floor"
        
        self._numOfFloorInputTextField = UITextField()
        self._numOfFloorInputTextField.layer.borderWidth = 2
        self._numOfFloorInputTextField.layer.borderColor = UIColor.black.cgColor
        self._numOfFloorInputTextField.keyboardType = .numberPad
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self._numOfFloorInputTextField.frame.height))
        self._numOfFloorInputTextField.leftView = paddingView
        self._numOfFloorInputTextField.leftViewMode = UITextFieldViewMode.always
        self._numOfFloorInputTextField.delegate = self
        
        self._numOfElevatorInputTextField = UITextField()
        self._numOfElevatorInputTextField.layer.borderWidth = 2
        self._numOfElevatorInputTextField.layer.borderColor = UIColor.black.cgColor
        self._numOfElevatorInputTextField.keyboardType = .numberPad
        let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self._numOfElevatorInputTextField.frame.height))
        self._numOfElevatorInputTextField.leftView = paddingView1
        self._numOfElevatorInputTextField.leftViewMode = UITextFieldViewMode.always
        self._numOfElevatorInputTextField.delegate = self
        
        self._timeMoveInputTextField = UITextField()
        self._timeMoveInputTextField.layer.borderWidth = 2
        self._timeMoveInputTextField.layer.borderColor = UIColor.black.cgColor
        self._timeMoveInputTextField.keyboardType = .numberPad
        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self._timeMoveInputTextField.frame.height))
        self._timeMoveInputTextField.leftView = paddingView2
        self._timeMoveInputTextField.leftViewMode = UITextFieldViewMode.always
        self._timeMoveInputTextField.delegate = self
        
        self._timePickupInputTextField = UITextField()
        self._timePickupInputTextField.layer.borderWidth = 2
        self._timePickupInputTextField.layer.borderColor = UIColor.black.cgColor
        self._timePickupInputTextField.keyboardType = .numberPad
        let paddingView3 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self._timePickupInputTextField.frame.height))
        self._timePickupInputTextField.leftView = paddingView3
        self._timePickupInputTextField.leftViewMode = UITextFieldViewMode.always
        self._timePickupInputTextField.delegate = self
        
        self._playButton = UIButton()
        self._playButton.layer.borderColor = UIColor.blue.cgColor
        self._playButton.layer.borderWidth = 2
        self._playButton.layer.cornerRadius = 8
        self._playButton.setTitle("Play", for: UIControlState.normal)
        self._playButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        self._playButton.backgroundColor = UIColor.blue
        self._playButton.addTarget(self, action: #selector(didTapPlayButton), for: UIControlEvents.touchUpInside)
        
        let tapViewGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        tapViewGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapViewGesture)
        
        self._numOfFloorInputTextField.text = "16"
        self._numOfElevatorInputTextField.text = "4"
        self._timeMoveInputTextField.text = "5.0"
        self._timePickupInputTextField.text = "3.0"
        
        //Not user in now
        //        self._decriptionInputTimeLabel.isHidden = true
        //        self._timeMoveInputTextField.isHidden = true
        
        self.view.addSubview(self._elevatorImageView)
        self.view.addSubview(self._decriptionInputNumFloorLabel)
        self.view.addSubview(self._decriptionInputNumElevatorLabel)
        self.view.addSubview(self._decriptionInputTimeLabel)
        self.view.addSubview(self._decriptionInputTimePickupLabel)
        self.view.addSubview(self._numOfFloorInputTextField)
        self.view.addSubview(self._numOfElevatorInputTextField)
        self.view.addSubview(self._timeMoveInputTextField)
        self.view.addSubview(self._timePickupInputTextField)
        self.view.addSubview(self._playButton)
    }
    
    private func setupLayout() {
        self._elevatorImageView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(230)
        }
        
        self._decriptionInputNumFloorLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(self._elevatorImageView.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalTo(self._numOfFloorInputTextField.snp.leading).offset(-10)
            make.height.equalTo(40)
        }
        
        self._numOfFloorInputTextField.snp.remakeConstraints { (make) in
            make.bottom.equalTo(self._decriptionInputNumFloorLabel)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(50)
        }
        
        self._decriptionInputNumElevatorLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(self._numOfFloorInputTextField.snp.bottom).offset(20)
            make.leading.equalTo(self._decriptionInputNumFloorLabel)
            make.trailing.equalTo(self._decriptionInputNumFloorLabel)
            make.height.equalTo(self._decriptionInputNumFloorLabel)
        }
        
        self._numOfElevatorInputTextField.snp.remakeConstraints { (make) in
            make.bottom.equalTo(self._decriptionInputNumElevatorLabel)
            make.width.equalTo(self._numOfFloorInputTextField)
            make.trailing.equalTo(self._numOfFloorInputTextField)
            make.height.equalTo(self._numOfFloorInputTextField)
        }
        
        self._decriptionInputTimeLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(self._numOfElevatorInputTextField.snp.bottom).offset(20)
            make.leading.equalTo(self._decriptionInputNumFloorLabel)
            make.trailing.equalTo(self._decriptionInputNumFloorLabel)
            make.height.equalTo(self._decriptionInputNumFloorLabel)
        }
        
        self._timeMoveInputTextField.snp.remakeConstraints { (make) in
            make.bottom.equalTo(self._decriptionInputTimeLabel)
            make.width.equalTo(self._numOfFloorInputTextField)
            make.trailing.equalTo(self._numOfFloorInputTextField)
            make.height.equalTo(self._numOfFloorInputTextField)
        }
        
        self._decriptionInputTimePickupLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(self._timeMoveInputTextField.snp.bottom).offset(20)
            make.leading.equalTo(self._decriptionInputNumFloorLabel)
            make.trailing.equalTo(self._decriptionInputNumFloorLabel)
            make.height.equalTo(self._decriptionInputNumFloorLabel)
        }
        
        self._timePickupInputTextField.snp.remakeConstraints { (make) in
            make.bottom.equalTo(self._decriptionInputTimePickupLabel)
            make.width.equalTo(self._numOfFloorInputTextField)
            make.trailing.equalTo(self._numOfFloorInputTextField)
            make.height.equalTo(self._numOfFloorInputTextField)
        }
        
        self._playButton.snp.remakeConstraints { (make) in
            make.top.equalTo(self._timePickupInputTextField.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(50)
        }
    }
    
    @objc private func didTapBackBarButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapPlayButton() {
        if let numFloorString = self._numOfFloorInputTextField.text,
            let numFloor = Int(numFloorString),
            let numElevatorString = self._numOfElevatorInputTextField.text,
            let numElevator = Int(numElevatorString),
            let timeMoveString = self._timeMoveInputTextField.text,
            let timeMoves = Float(timeMoveString),
            let timePickupString = self._timePickupInputTextField.text,
            let timePickup = Float(timePickupString),
            numFloor > 0, numElevator > 0, timeMoves > 0, timePickup > 0 {
            UserDefaults.standard.set(numFloor, forKey: "num_floor")
            UserDefaults.standard.set(numElevator, forKey: "num_elevator")
            UserDefaults.standard.set(timeMoves, forKey: "time_moves_on_each_floor")
            UserDefaults.standard.set(timePickup, forKey: "time_pickup_on_each_floor")
            
            self.navigateToElevatorViewController()
        } else {
            PopupManager.showPopup(title: "Error", message: "Please input valid number. ", completion: {
                //do nothing
            }, actionHandle: {
                //do nothing
            })
        }
    }
    
    private func navigateToElevatorViewController() {
        let assignedVC = ElevatorViewController()
        let nc = UINavigationController(rootViewController: assignedVC)
        nc.modalPresentationStyle = .overFullScreen
        self.present(nc, animated: true)
    }
    
    @objc private func didTapView() {
        self.closeAllInputs()
    }
    
    private func closeAllInputs() {
        self._numOfElevatorInputTextField.resignFirstResponder()
        self._numOfFloorInputTextField.resignFirstResponder()
    }
    
    @objc private func keyboardWillShow(_ noti: Notification) {
        if let keyboardSize = (noti.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            let movementDistance: CGFloat = keyboardSize.height
            let movementDuration: Double = 0.4
            
            let movement: CGFloat = -movementDistance
            UIView.beginAnimations("animateTextField", context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(movementDuration)
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
            UIView.commitAnimations()
        }
    }
    
    @objc private func keyboardWillHide(_ noti: Notification) {
        if let keyboardSize = (noti.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            let movementDistance: CGFloat = keyboardSize.height
            let movementDuration: Double = 0.26
            
            let movement: CGFloat = movementDistance
            UIView.beginAnimations("animateTextField", context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(movementDuration)
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
            UIView.commitAnimations()
        }
    }
}

