//
//  UserService.swift
//  kokoMates-demo
//
//  Created by ZHI on 2024/12/27.
//

import Alamofire

public struct UserService {
    
    public struct getUser: HttpTargetType {
        public var path: String { "man.json" }
        public var method: Alamofire.HTTPMethod { .get }
        
        public typealias SuccessType = UserResponseModel
        public typealias FailureType = ResponseFailure
    }
}
