//
//  UserAuthManager.swift
//  Umbala-Interview-Test
//
//  Created by Nguyen Van Uy on 4/13/18.
//  Copyright © 2018 Uy Nguyen Van. All rights reserved.
//

import Foundation

class UserAuthManager {
    static let instance: UserAuthManager = UserAuthManager()
    
    var isAuthorized: Bool {
        get {
            if let token = token {
                return (!token.isEmpty && token != "") ? true : false
            }
            return false
        }
    }
    
    var token: String? = nil
    var userInfo: InstagramUserInfo? = nil
    
    init() {
        self.token = nil
        self.userInfo = nil
    }
    
    func logout() {
        self.token = nil
        self.userInfo = nil
        
        self.clearBrowserCache()
    }
    
    private func clearBrowserCache() {
        URLCache.shared.removeAllCachedResponses()
        
        // Delete any associated cookies
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
}
