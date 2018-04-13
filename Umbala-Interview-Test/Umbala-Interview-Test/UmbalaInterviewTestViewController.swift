//
//  UmbalaInterviewTestViewController.swift
//  Umbala-Interview-Test
//
//  Created by Nguyen Van Uy on 4/13/18.
//  Copyright © 2018 Uy Nguyen Van. All rights reserved.
//

import Foundation
import UIKit

class UmbalaInterviewTestViewController: UIViewController {
    private var _copyrightLabel: UILabel!
    private var _welcomeLabel: UILabel!
    private var _umbalaAbilityTestLabel: UILabel!
    
    private var _elevatorTestButton: UIButton!
    private var _matrixRotationTestButton: UIButton!
    private var _instagramTestButton: UIButton!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        self.setupView()
        self.setupLayout()
    }
    
    private func setupView() {
        self._copyrightLabel = UILabel()
        self._copyrightLabel.textColor = UIColor.darkGray
        self._copyrightLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        self._copyrightLabel.textAlignment = .center
        self._copyrightLabel.text = "Copyright (c) 2018 by nguyenvanuyn96"
        
        self._elevatorTestButton = UIButton()
        self._elevatorTestButton.layer.borderColor = UIColor.blue.cgColor
        self._elevatorTestButton.layer.borderWidth = 2
        self._elevatorTestButton.layer.cornerRadius = 8
        self._elevatorTestButton.setTitle("Elevator", for: UIControlState.normal)
        self._elevatorTestButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        self._elevatorTestButton.backgroundColor = UIColor.blue
        self._elevatorTestButton.addTarget(self, action: #selector(didTapElevatorTestButton), for: UIControlEvents.touchUpInside)
        
        self._matrixRotationTestButton = UIButton()
        self._matrixRotationTestButton.layer.borderColor = UIColor.cyan.cgColor
        self._matrixRotationTestButton.layer.borderWidth = 2
        self._matrixRotationTestButton.layer.cornerRadius = 8
        self._matrixRotationTestButton.setTitle("Matrix Rotation", for: UIControlState.normal)
        self._matrixRotationTestButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        self._matrixRotationTestButton.backgroundColor = UIColor.cyan
        self._matrixRotationTestButton.addTarget(self, action: #selector(didTapMatrixRotationTestButton), for: UIControlEvents.touchUpInside)
        
        self._instagramTestButton = UIButton()
        self._instagramTestButton.layer.borderColor = UIColor.purple.cgColor
        self._instagramTestButton.layer.borderWidth = 2
        self._instagramTestButton.layer.cornerRadius = 8
        self._instagramTestButton.setTitle("Instagram", for: UIControlState.normal)
        self._instagramTestButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        self._instagramTestButton.backgroundColor = UIColor.purple
        self._instagramTestButton.addTarget(self, action: #selector(didTapInstagramTestButton), for: UIControlEvents.touchUpInside)
        
        self._welcomeLabel = UILabel()
        self._welcomeLabel.textColor = UIColor.black
        self._welcomeLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        self._welcomeLabel.textAlignment = .center
        self._welcomeLabel.text = "Welcome to"
        
        self._umbalaAbilityTestLabel = UILabel()
        self._umbalaAbilityTestLabel.textColor = UIColor.black
        self._umbalaAbilityTestLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        self._umbalaAbilityTestLabel.textAlignment = .center
        self._umbalaAbilityTestLabel.text = "Umbala Ability Test"
        
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self._instagramTestButton)
        self.view.addSubview(self._elevatorTestButton)
        self.view.addSubview(self._matrixRotationTestButton)
        self.view.addSubview(self._copyrightLabel)
        self.view.addSubview(self._welcomeLabel)
        self.view.addSubview(self._umbalaAbilityTestLabel)
    }
    
    private func setupLayout() {
        self._copyrightLabel.snp.remakeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        self._welcomeLabel.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview().multipliedBy(0.4)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        self._umbalaAbilityTestLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(self._welcomeLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        self._elevatorTestButton.snp.remakeConstraints { (make) in
            make.top.equalTo(self._umbalaAbilityTestLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        self._matrixRotationTestButton.snp.remakeConstraints { (make) in
            make.top.equalTo(self._elevatorTestButton.snp.bottom).offset(30)
            make.centerX.equalTo(self._elevatorTestButton)
            make.height.equalTo(self._elevatorTestButton)
            make.width.equalTo(self._elevatorTestButton)
        }
        
        self._instagramTestButton.snp.remakeConstraints { (make) in
            make.top.equalTo(self._matrixRotationTestButton.snp.bottom).offset(30)
            make.centerX.equalTo(self._elevatorTestButton)
            make.height.equalTo(self._elevatorTestButton)
            make.width.equalTo(self._elevatorTestButton)
        }
    }
    
    @objc private func didTapElevatorTestButton() {
        let assignedVC = SetupElevatorViewController()
        self.navigationController?.pushViewController(assignedVC, animated: true)
    }
    
    @objc private func didTapMatrixRotationTestButton() {
//        let assignedVC = MatrixRotationViewController()
//        self.navigationController?.pushViewController(assignedVC, animated: true)
    }
    
    @objc private func didTapInstagramTestButton() {
        let assignedVC = WelcomeViewController()
        self.navigationController?.pushViewController(assignedVC, animated: true)
    }
}
