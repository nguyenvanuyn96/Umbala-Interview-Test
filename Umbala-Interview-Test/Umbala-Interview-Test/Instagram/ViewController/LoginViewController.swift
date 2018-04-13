//
//  LoginViewController.swift
//  Umbala-Interview-Test
//
//  Created by Nguyen Van Uy on 4/13/18.
//  Copyright © 2018 Uy Nguyen Van. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class LoginViewController: UIViewController, UIWebViewDelegate {
    private var _webView: UIWebView!
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
        self.setupView()
        self.setupLayout()
        
        // Do any additional setup after loading the view, typically from a nib.
        let url = NSURL(string: "\(InstagramAPIConstant.INSTAGRAM_AUTHURL)?client_id=\(InstagramAPIConstant.INSTAGRAM_CLIENT_ID)&redirect_uri=\(InstagramAPIConstant.INSTAGRAM_REDIRECT_URI)&response_type=token&scope=\(InstagramAPIConstant.INSTAGRAM_SCOPE)")
        if let url = url as URL? {
            let requestObj = URLRequest(url: url)
            self._webView.loadRequest(requestObj)
        }
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return checkRequestForCallbackURL(request: request)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        //Loading here
        self._loadingView = UIViewController.showLoading(onView: self.view)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //Hide loading here
        UIViewController.hideLoading(view: self._loadingView)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        //Hide loading here and show error popup
        UIViewController.hideLoading(view: self._loadingView)
    }
    
    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.hasPrefix(InstagramAPIConstant.INSTAGRAM_REDIRECT_URI) {
            let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
            self.handleAuth(authToken: requestURLString.substring(from: range.upperBound))
            return false
        }
        return true
    }
    
    private func handleAuth(authToken: String) {
        print("Instagram authentication token ==", authToken)
        
        UserAuthManager.instance.token = authToken
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationKey.UMBALA_ABILITY_TEST_LOGIN_SUCCESS), object: nil, userInfo: nil)
        self.doCloseViewController()
    }
    
    private func setupView() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.plain, target: self, action: #selector(didTapCloseBarButton))
        
        self._webView = UIWebView()
        self._webView.contentMode = UIViewContentMode.scaleAspectFit
        self._webView.delegate = self
        self.view.addSubview(self._webView)
        
        self.view.backgroundColor = UIColor.lightGray
        
        self._webView.backgroundColor = UIColor.blue
        
        self.edgesForExtendedLayout = []
    }
    
    private func setupLayout() {
        self._webView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func doCloseViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapCloseBarButton() {
        self.doCloseViewController()
    }
}

