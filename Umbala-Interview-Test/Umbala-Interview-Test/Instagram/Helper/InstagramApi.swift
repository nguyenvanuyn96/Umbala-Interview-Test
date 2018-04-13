//
//  InstagramApi.swift
//  Umbala-Interview-Test
//
//  Created by Nguyen Van Uy on 4/13/18.
//  Copyright © 2018 Uy Nguyen Van. All rights reserved.
//

import Foundation
import Alamofire

class InstagramApi {
    
    private static let _sessionManager = Alamofire.SessionManager()
    private static let _queue = DispatchQueue(label: "org.misfit.api-client." + UUID().uuidString)
    
    static func getCurrentUserInfo(accessToken: String, success: @escaping (_ userInfo: InstagramUserInfo) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        var parameters = Parameters()
        parameters["access_token"] = accessToken
        
        self.request("https://api.instagram.com/v1/users/self", method: .get, parameters: parameters, success: { (jsonData) in
            if let json = jsonData as? NSDictionary, let userInfoJson = json.value(forKeyPath: "data"), let userInfoData = try? JSONSerialization.data(withJSONObject: userInfoJson), let userInfo = try? JSONDecoder().decode(InstagramUserInfo.self, from: userInfoData) {
                success(userInfo)
            } else {
                failure(NSError(domain: "InvalidResponse", code: 505, userInfo: nil))
            }
        }) { (error) in
            failure(error)
        }
    }
    
    static func getFollowings(accessToken: String, success: @escaping (_ followingsUserInfo: [InstagramUserInfo]) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        var parameters = Parameters()
        parameters["access_token"] = accessToken
        
        self.request("https://api.instagram.com/v1/users/self/follows", method: .get, parameters: parameters, success: { (jsonData) in
            if let json = jsonData as? NSDictionary, let userInfoJson = json.value(forKeyPath: "data"), let userInfoData = try? JSONSerialization.data(withJSONObject: userInfoJson), let usersInfo = try? JSONDecoder().decode([InstagramUserInfo].self, from: userInfoData) {
                success(usersInfo)
            } else {
                failure(NSError(domain: "InvalidResponse", code: 505, userInfo: nil))
            }
        }) { (error) in
            failure(error)
        }
    }
    
    static func unfollow(withUserId userId: String, accessToken: String, success: @escaping (_ newRelationship: InstagramRelationship) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        self.changeRelationship(withUserId: userId, accessToken: accessToken, action: "unfollow", success: success, failure: failure)
    }
    
    static func follow(withUserId userId: String, accessToken: String, success: @escaping (_ newRelationship: InstagramRelationship) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        self.changeRelationship(withUserId: userId, accessToken: accessToken, action: "follow", success: success, failure: failure)
    }
    
    static func checkRelationship(withUserId userId: String, accessToken: String, success: @escaping (_ relationship: InstagramRelationship) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        //TODO
    }
    
    private static func changeRelationship(withUserId userId: String, accessToken: String, action: String, success: @escaping (_ newRelationship: InstagramRelationship) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        var parameters = Parameters()
        parameters["access_token"] = accessToken
        parameters["action"] = action
        
        self.request("https://api.instagram.com/v1/users/\(userId)/relationship", method: .post, parameters: parameters, success: { (jsonData) in
            if let json = jsonData as? NSDictionary, let relationshipJson = json.value(forKeyPath: "data"), let relationshipData = try? JSONSerialization.data(withJSONObject: relationshipJson), let relationship = try? JSONDecoder().decode(InstagramRelationship.self, from: relationshipData) {
                success(relationship)
            } else {
                failure(NSError(domain: "InvalidResponse", code: 505, userInfo: nil))
            }
        }) { (error) in
            failure(error)
        }
    }
    
    private static func request(_ url: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, success: @escaping (_ jsonData: Any) -> Void, failure: @escaping (_ error: NSError) -> Void)
    {
        var cumulateHeader: HTTPHeaders = [:]
        cumulateHeader["Content-Type"] = "application/x-www-form-urlencoded"
        
        let completion: (DataResponse<Any>) -> Void = { (response) -> Void in
            switch response.result {
            case .success(let value):
                success(value)
            case .failure(let error):
                failure(error as NSError)
            }
        }
        
        self._sessionManager.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: cumulateHeader).validate().responseJSON(queue: self._queue, completionHandler: completion)
    }
}
