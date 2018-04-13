//
//  Constants.swift
//  Umbala-Interview-Test
//
//  Created by Nguyen Van Uy on 4/13/18.
//  Copyright © 2018 Uy Nguyen Van. All rights reserved.
//

import Foundation

struct InstagramAPIConstant {
    static let INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize/"
    static let INSTAGRAM_CLIENT_ID = "61aa9860520748fd90816f630fdc35eb"
    static let INSTAGRAM_CLIENTSERCRET = "8d62f0359b1a4019982a8950f4297b8d"
    static let INSTAGRAM_REDIRECT_URI = "https://umbala.tv"
    static let INSTAGRAM_ACCESS_TOKEN = "access_token"
    static let INSTAGRAM_SCOPE = "follower_list+relationships"
}

struct NotificationKey {
    static let UMBALA_ABILITY_TEST_LOGIN_SUCCESS = "UMBALA_ABILITY_TEST_LOGIN_SUCCESS"
    static let UMBALA_ABILITY_TEST_ELEVATOR_FREE_REQUEST = "UMBALA_ABILITY_TEST_ELEVATOR_FREE_REQUEST"
}
