//
//  FollowingViewController.swift
//  Umbala-Interview-Test
//
//  Created by Nguyen Van Uy on 4/13/18.
//  Copyright © 2018 Uy Nguyen Van. All rights reserved.
//

import Foundation
import UIKit

protocol FollowingTableViewCellDelegate: class {
    func didTapUnfollowButton(userInfo: InstagramUserInfo)
    func didTapFollowButton(userInfo: InstagramUserInfo)
}

class FollowingTableViewCell: UITableViewCell {
    static var CELL_IDENTIFIER: String { return "FollowingTableViewCell" }
    
    private var _fullNameLabel: UILabel!
    private var _userAvatarImageView: UIImageView!
    private var _usernameLabel: UILabel!
    private var _followingButton: UIButton!
    private var _userInfo: InstagramUserInfo!
    
    var delegate: FollowingTableViewCellDelegate?
    
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
        self._fullNameLabel = UILabel()
        self._fullNameLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        self._fullNameLabel.numberOfLines = 1
        self._fullNameLabel.lineBreakMode = .byTruncatingTail
        
        self._usernameLabel = UILabel()
        self._usernameLabel.textColor = UIColor.lightGray
        self._usernameLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        self._usernameLabel.numberOfLines = 1
        self._usernameLabel.lineBreakMode = .byTruncatingTail
        
        self._userAvatarImageView = UIImageView(image: UIImage(named:"user_avatar_placeholder"))
        self._userAvatarImageView.contentMode = UIViewContentMode.center
        self._userAvatarImageView.layer.cornerRadius = 30
        self._userAvatarImageView.clipsToBounds = true
        
        self._followingButton = UIButton()
        self._followingButton.layer.borderColor = UIColor.blue.cgColor
        self._followingButton.layer.borderWidth = 2
        self._followingButton.layer.cornerRadius = 8
        self._followingButton.setTitle("Following", for: UIControlState.normal)
        self._followingButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        self._followingButton.backgroundColor = UIColor.blue
        self._followingButton.addTarget(self, action: #selector(didTapFollowingButton), for: UIControlEvents.touchUpInside)
        
        self.addSubview(self._userAvatarImageView)
        self.addSubview(self._usernameLabel)
        self.addSubview(self._fullNameLabel)
        self.addSubview(self._followingButton)
    }
    
    /// Setup Layout for view component.
    private func setupLayout() {
        self._userAvatarImageView.snp.remakeConstraints { (make) in
            make.width.equalTo(60)
            make.height.equalTo(self._userAvatarImageView.snp.width)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        
        self._fullNameLabel.snp.remakeConstraints { (make) in
            make.centerY.equalTo(self._userAvatarImageView.snp.centerY).multipliedBy(0.75)
            make.leading.equalTo(self._userAvatarImageView.snp.trailing).offset(20)
            make.trailing.equalTo(self._followingButton.snp.leading).offset(-12)
        }
        
        self._usernameLabel.snp.remakeConstraints { (make) in
            make.leading.equalTo(self._fullNameLabel)
            make.trailing.equalTo(self._fullNameLabel)
            make.centerY.equalTo(self._userAvatarImageView.snp.centerY).multipliedBy(1.55)
        }
        
        self._followingButton.snp.remakeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-12)
            make.width.equalTo(100)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    func configureCell(withUserInfo userInfo: InstagramUserInfo) {
        self._userInfo = userInfo
        
        self._userAvatarImageView.downloadedFrom(link: userInfo.profilePictureUrl)
        self._usernameLabel.text = userInfo.username
        self._fullNameLabel.text = userInfo.fullName
        if userInfo.isFollowing {
            self._followingButton.setTitle("Unfollow", for: UIControlState.normal)
        } else {
            self._followingButton.setTitle("Follow", for: UIControlState.normal)
        }
    }
    
    @objc private func didTapFollowingButton() {
        if self._userInfo.isFollowing {
            self.delegate?.didTapUnfollowButton(userInfo: self._userInfo)
        } else {
            self.delegate?.didTapFollowButton(userInfo: self._userInfo)
        }
    }
}

class FollowingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FollowingTableViewCellDelegate {
    
    private var _loadingView: UIView!
    private var _tableView: UITableView!
    private var _followingArr: [InstagramUserInfo] = [InstagramUserInfo]()
    private var _userAuthManager: UserAuthManager!
    
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
        
        self._userAuthManager = UserAuthManager.instance
        
        self.getFollowingsList()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._followingArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FollowingTableViewCell.CELL_IDENTIFIER) as! FollowingTableViewCell
        cell.delegate = self
        if let userInfo = self._followingArr[atIndex: indexPath.row] {
            cell.configureCell(withUserInfo: userInfo)
        }
        
        return cell
    }
    
    //MARK: - FollowingTableViewCellDelegate
    func didTapUnfollowButton(userInfo: InstagramUserInfo) {
        self.doUnfollow(userId: userInfo.id)
    }
    
    func didTapFollowButton(userInfo: InstagramUserInfo) {
        self.doFollow(userId: userInfo.id)
    }
    
    
    //MARK: - Private methods
    private func setupView() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(didTapBackBarButton))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Unfollow All", style: UIBarButtonItemStyle.plain, target: self, action: #selector(didTapRightBarButton))
        
        self._tableView = UITableView()
        self._tableView.register(FollowingTableViewCell.self, forCellReuseIdentifier: FollowingTableViewCell.CELL_IDENTIFIER)
        self._tableView.delegate = self
        self._tableView.dataSource = self
        
        self.view.addSubview(self._tableView)
    }
    
    private func setupLayout() {
        self._tableView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
    }
    
    @objc private func didTapBackBarButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapRightBarButton() {
        if let rightBarButton = self.navigationItem.rightBarButtonItem, let title = rightBarButton.title {
            if title == "Follow All" {
                self.doFollowAll()
            } else if title == "Unfollow All" {
                self.doUnfollowAll()
            }
        }
    }
    
    private func doFollowAll() {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        if self._userAuthManager.isAuthorized, let accessToken = self._userAuthManager.token {
            let dispatchGroup = DispatchGroup()
            var isFollowSuccess = false
            self._loadingView = UIViewController.showLoading(onView: self.view)
            for userInfo in self._followingArr {
                dispatchGroup.enter()
                if !userInfo.isFollowing {
                    InstagramApi.follow(withUserId: userInfo.id, accessToken: accessToken, success: { [weak self] (newRelationship) in
                        guard let strongSelf = self else { return }
                        
                        dispatchGroup.leave()
                        
                        if newRelationship.outgoingStatus == InstagramRelationshipType.follows, let index = strongSelf._followingArr.index(where: { $0.id == userInfo.id }) {
                            //reload cell include this user
                            userInfo.isFollowing = true
                            let indexPath = IndexPath(row: index, section: 0)
                            DispatchQueue.main.async(execute: {
                                strongSelf._tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                            })
                            
                            isFollowSuccess = true
                        } else {
                            PopupManager.showPopup(title: "Error", message: "Can't follow \(userInfo.fullName). Please try again later!", completion: {
                                //do nothing
                            }, actionHandle: {
                                //do nothing
                            })
                        }
                        }, failure: { [weak self] (error) in
                            guard let strongSelf = self else { return }
                            
                            dispatchGroup.leave()
                            
                            PopupManager.showPopup(title: "Error", message: "Can't follow \(userInfo.fullName). Please try again later!\n \(error.description)", completion: {
                                //do nothing
                            }, actionHandle: {
                                //do nothing
                            })
                    })
                }
            }
            
            dispatchGroup.notify(queue: DispatchQueue.main) {
                UIViewController.hideLoading(view: self._loadingView)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                if isFollowSuccess {
                    self.navigationItem.rightBarButtonItem?.title = "Unfollow All"
                }
            }
        }
    }
    
    private func doUnfollowAll() {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        if self._userAuthManager.isAuthorized, let accessToken = self._userAuthManager.token {
            let dispatchGroup = DispatchGroup()
            var isUnfollowSuccess = false
            self._loadingView = UIViewController.showLoading(onView: self.view)
            for userInfo in self._followingArr {
                dispatchGroup.enter()
                if userInfo.isFollowing {
                    InstagramApi.unfollow(withUserId: userInfo.id, accessToken: accessToken, success: { [weak self] (newRelationship) in
                        guard let strongSelf = self else { return }
                        
                        dispatchGroup.leave()
                        
                        if newRelationship.outgoingStatus == InstagramRelationshipType.none, let index = strongSelf._followingArr.index(where: { $0.id == userInfo.id }) {
                            //reload cell include this user
                            userInfo.isFollowing = false
                            let indexPath = IndexPath(row: index, section: 0)
                            DispatchQueue.main.async(execute: {
                                strongSelf._tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                            })
                            isUnfollowSuccess = true
                        } else {
                            PopupManager.showPopup(title: "Error", message: "Can't unfollow \(userInfo.fullName). Please try again later!", completion: {
                                //do nothing
                            }, actionHandle: {
                                //do nothing
                            })
                        }
                        }, failure: { [weak self] (error) in
                            guard let strongSelf = self else { return }
                            
                            dispatchGroup.leave()
                            
                            PopupManager.showPopup(title: "Error", message: "Can't unfollow \(userInfo.fullName). Please try again later!\n \(error.description)", completion: {
                                //do nothing
                            }, actionHandle: {
                                //do nothing
                            })
                    })
                }
            }
            
            dispatchGroup.notify(queue: DispatchQueue.main) {
                UIViewController.hideLoading(view: self._loadingView)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                if isUnfollowSuccess {
                    self.navigationItem.rightBarButtonItem?.title = "Follow All"
                }
            }
        }
    }
    
    private func doUnfollow(userId: String) {
        if self._userAuthManager.isAuthorized, let accessToken = self._userAuthManager.token {
            //Loading here
            self._loadingView = UIViewController.showLoading(onView: self.view)
            
            InstagramApi.unfollow(withUserId: userId, accessToken: accessToken, success: { [weak self] (newRelationship) in
                guard let strongSelf = self else { return }
                DispatchQueue.main.async(execute: {
                    UIViewController.hideLoading(view: strongSelf._loadingView)
                })
                
                if newRelationship.outgoingStatus == InstagramRelationshipType.none, let index = strongSelf._followingArr.index(where: { $0.id == userId }) {
                    strongSelf._followingArr[index].isFollowing = false
                    let indexPath = IndexPath(row: index, section: 0)
                    DispatchQueue.main.async(execute: {
                        strongSelf._tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                    })
                } else {
                    PopupManager.showPopup(title: "Error", message: "Can't unfollow this friend. Please try again later!", completion: {
                        //do nothing
                    }, actionHandle: {
                        //do nothing
                    })
                }
                }, failure: { [weak self] (error) in
                    guard let strongSelf = self else { return }
                    DispatchQueue.main.async(execute: {
                        UIViewController.hideLoading(view: strongSelf._loadingView)
                    })
                    
                    PopupManager.showPopup(title: "Error", message: "Can't unfollow this friend. Please try again later!\n \(error.description)", completion: {
                        //do nothing
                    }, actionHandle: {
                        //do nothing
                    })
            })
        }
    }
    
    
    private func doFollow(userId: String) {
        if self._userAuthManager.isAuthorized, let accessToken = self._userAuthManager.token {
            //Loading here
            DispatchQueue.main.async(execute: {
                self._loadingView = UIViewController.showLoading(onView: self.view)
            })
            
            InstagramApi.follow(withUserId: userId, accessToken: accessToken, success: { [weak self] (newRelationship) in
                guard let strongSelf = self else { return }
                
                DispatchQueue.main.async(execute: {
                    UIViewController.hideLoading(view: strongSelf._loadingView)
                })
                
                if newRelationship.outgoingStatus == .follows, let index = strongSelf._followingArr.index(where: { $0.id == userId }) {
                    strongSelf._followingArr[index].isFollowing = false
                    let indexPath = IndexPath(row: index, section: 0)
                    DispatchQueue.main.async(execute: {
                        strongSelf._tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                    })
                } else {
                    PopupManager.showPopup(title: "Error", message: "Can't follow this account. Please try again later!", completion: {
                        //do nothing
                    }, actionHandle: {
                        //do nothing
                    })
                }
                }, failure: { [weak self] (error) in
                    guard let strongSelf = self else { return }
                    UIViewController.hideLoading(view: strongSelf._loadingView)
                    
                    PopupManager.showPopup(title: "Error", message: "Can't follow this account. Please try again later!\n \(error.description)", completion: {
                        //do nothing
                    }, actionHandle: {
                        //do nothing
                    })
            })
        }
    }
    
    private func getFollowingsList() {
        if self._userAuthManager.isAuthorized, let accessToken = self._userAuthManager.token {
            //Loading here
            DispatchQueue.main.async(execute: {
                self._loadingView = UIViewController.showLoading(onView: self.view)
            })
            
            InstagramApi.getFollowings(accessToken: accessToken, success: { [weak self] (userInfoArr) in
                //todo
                guard let strongSelf = self else { return }
                
                strongSelf._followingArr = userInfoArr
                
                DispatchQueue.main.async(execute: {
                    UIViewController.hideLoading(view: strongSelf._loadingView)
                    strongSelf._tableView.reloadData()
                })
                }, failure: { [weak self] (error) in
                    //todo
                    guard let strongSelf = self else { return }
                    DispatchQueue.main.async(execute: {
                        UIViewController.hideLoading(view: strongSelf._loadingView)
                    })
                    
                    PopupManager.showPopup(title: "Error", message: "Can't get following list. Please try again later!", completion: {
                        //do nothing
                    }, actionHandle: {
                        //logout
                        strongSelf.navigationController?.popViewController(animated: true)
                    })
                    
            })
        }
    }
    
}

