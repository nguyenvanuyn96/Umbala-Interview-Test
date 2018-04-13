//
//  WelcomeViewController.swift
//  Umbala-Interview-Test
//
//  Created by Nguyen Van Uy on 4/13/18.
//  Copyright © 2018 Uy Nguyen Van. All rights reserved.
//

import Foundation

import UIKit

class WelcomeViewController: UIViewController {
    private var _logoImage: UIImageView!
    private var _logoTextImageView: UIImageView!
    private var _userAvatarImageView: UIImageView!
    private var _userNameLabel: UILabel!
    
    private var _loginButton: UIButton!
    private var _logoutButton: UIButton!
    private var _followingsButton: UIButton!
    private var _userAuthManager: UserAuthManager!
    private var _loadingView: UIView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        self._userAuthManager = UserAuthManager.instance
        
        NotificationCenter.default.addObserver(self, selector: #selector(didLoginSuccess), name: NSNotification.Name(rawValue: NotificationKey.UMBALA_ABILITY_TEST_LOGIN_SUCCESS), object: nil)
        
        self.setupView()
        self.setupLayout()
        
        self._userAuthManager.logout()
    }
    
    
    private func setupView() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(didTapBackBarButton))
        
        self._loginButton = UIButton()
        self._loginButton.layer.borderColor = UIColor.blue.cgColor
        self._loginButton.layer.borderWidth = 2
        self._loginButton.layer.cornerRadius = 8
        self._loginButton.setTitle("Login Instagram", for: UIControlState.normal)
        self._loginButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        self._loginButton.backgroundColor = UIColor.blue
        self._loginButton.addTarget(self, action: #selector(didTapLoginButton), for: UIControlEvents.touchUpInside)
        
        self._logoutButton = UIButton()
        self._logoutButton.layer.borderColor = UIColor.blue.cgColor
        self._logoutButton.layer.borderWidth = 2
        self._logoutButton.layer.cornerRadius = 8
        self._logoutButton.setTitle("Sign out", for: UIControlState.normal)
        self._loginButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        self._logoutButton.backgroundColor = UIColor.blue
        self._logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: UIControlEvents.touchUpInside)
        
        self._followingsButton = UIButton()
        self._followingsButton.layer.borderColor = UIColor.blue.cgColor
        self._followingsButton.layer.borderWidth = 2
        self._followingsButton.layer.cornerRadius = 8
        self._followingsButton.setTitle("Get Followings", for: UIControlState.normal)
        self._loginButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        self._followingsButton.backgroundColor = UIColor.blue
        self._followingsButton.addTarget(self, action: #selector(didTapFollowingsButton), for: UIControlEvents.touchUpInside)
        
        self._logoImage = UIImageView(image: UIImage(named: "instagram_icon_png"))
        self._logoImage.contentMode = UIViewContentMode.scaleAspectFit
        
        self._logoTextImageView = UIImageView(image: UIImage(named: "instagram_logo_text"))
        self._logoTextImageView.contentMode = UIViewContentMode.scaleAspectFit
        
        self._userAvatarImageView = UIImageView(image: UIImage(named:"user_avatar_placeholder"))
        self._userAvatarImageView.contentMode = UIViewContentMode.center
        self._userAvatarImageView.layer.cornerRadius = 30
        self._userAvatarImageView.clipsToBounds = true
        
        self._userNameLabel = UILabel()
        self._userNameLabel.textColor = UIColor.blue
        self._userNameLabel.textAlignment = .center
        
        self.hideLoginButton(isHide: false)
        
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(didTapBackBarButton))
        
        self.view.addSubview(self._loginButton)
        self.view.addSubview(self._logoutButton)
        self.view.addSubview(self._followingsButton)
        self.view.addSubview(self._logoImage)
        self.view.addSubview(self._logoTextImageView)
        self.view.addSubview(self._userAvatarImageView)
        self.view.addSubview(self._userNameLabel)
    }
    
    private func hideLoginButton(isHide: Bool) {
        self._loginButton.isHidden = isHide
        
        self._logoutButton.isHidden = !isHide
        self._followingsButton.isHidden = !isHide
        self._userNameLabel.isHidden = !isHide
        self._userAvatarImageView.isHidden = !isHide
    }
    
    private func setupLayout() {
        self._logoImage.snp.remakeConstraints { (make) in
            make.bottom.equalTo(self._logoTextImageView.snp.top).offset(-10)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
        }
        
        self._logoTextImageView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.view.snp.centerY).multipliedBy(0.5)
            make.centerX.equalToSuperview()
            make.height.equalTo(100)
        }
        
        self._userAvatarImageView.snp.remakeConstraints { (make) in
            make.top.equalTo(self._logoTextImageView.snp.bottom).offset(20)
            make.height.equalTo(60)
            make.width.equalTo(self._userAvatarImageView.snp.height)
            make.centerX.equalToSuperview()
        }
        
        self._userNameLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(self._userAvatarImageView.snp.bottom).offset(8)
            make.centerX.equalTo(self._userAvatarImageView.snp.centerX)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
        
        self._loginButton.snp.remakeConstraints { (make) in
            make.top.equalTo(self._logoTextImageView.snp.bottom).offset(200)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        self._followingsButton.snp.remakeConstraints { (make) in
            make.top.equalTo(self._loginButton)
            make.height.equalTo(self._loginButton)
            make.width.equalTo(150)
            make.centerX.equalToSuperview().multipliedBy(0.5)
        }
        
        self._logoutButton.snp.remakeConstraints { (make) in
            make.top.equalTo(self._loginButton)
            make.height.equalTo(self._loginButton)
            make.width.equalTo(100)
            make.centerX.equalToSuperview().multipliedBy(1.5)
        }
    }
    
    @objc private func didTapLoginButton() {
        let assignedVC = LoginViewController()
        let nc = UINavigationController(rootViewController: assignedVC)
        nc.modalPresentationStyle = .overFullScreen
        self.present(nc, animated: true)
    }
    
    @objc private func didTapLogoutButton() {
        self.doLogout()
    }
    
    private func doLogout() {
        self._userAuthManager.logout()
        self.hideLoginButton(isHide: false)
    }
    
    @objc private func didTapFollowingsButton() {
        let assignVC = FollowingViewController()
        self.navigationController?.pushViewController(assignVC, animated: true)
    }
    
    @objc private func didLoginSuccess() {
        self.getUserInfo()
    }
    
    @objc private func didTapBackBarButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func getUserInfo() {
        if self._userAuthManager.isAuthorized, let accessToken = self._userAuthManager.token {
            //Loading here
            self._loadingView = UIViewController.showLoading(onView: self.view)
            
            InstagramApi.getCurrentUserInfo(accessToken: accessToken, success: { [weak self] (userInfo) in
                guard let strongSelf = self else { return }
                
                DispatchQueue.main.async(execute: {
                    UIViewController.hideLoading(view: strongSelf._loadingView)
                    
                    strongSelf._userAuthManager.userInfo = userInfo
                    strongSelf.hideLoginButton(isHide: true)
                    strongSelf._userAvatarImageView.downloadedFrom(link: userInfo.profilePictureUrl)
                    strongSelf._userNameLabel.text = userInfo.fullName
                })
                }, failure: { [weak self] (error) in
                    guard let strongSelf = self else { return }
                    
                    DispatchQueue.main.async(execute: {
                        UIViewController.hideLoading(view: strongSelf._loadingView)
                        strongSelf.doLogout()
                        
                        PopupManager.showPopup(title: "Error", message: "Can't get current user info!", completion: {
                            //do nothing
                        }, actionHandle: {
                            //logout
                            strongSelf._userAuthManager.logout()
                        })
                    })
            })
        }
    }
}
