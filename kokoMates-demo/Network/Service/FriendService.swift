//
//  FriendService.swift
//  kokoMates-demo
//
//  Created by ZHI on 2024/12/27.
//

import Alamofire

public struct FriendService {
    
    public struct getFriendOne: HttpTargetType {
        public var path: String { "friend1.json" }
        public var method: Alamofire.HTTPMethod { .get }
        
        public typealias SuccessType = FriendResponseModel
        public typealias FailureType = ResponseFailure
    }
    
    public struct getFriendTwo: HttpTargetType {
        public var path: String { "friend2.json" }
        public var method: Alamofire.HTTPMethod { .get }
        
        public typealias SuccessType = FriendResponseModel
        public typealias FailureType = ResponseFailure
    }
    
    public struct getFriendRequest: HttpTargetType {
        public var path: String { "friend3.json" }
        public var method: Alamofire.HTTPMethod { .get }
        
        public typealias SuccessType = FriendResponseModel
        public typealias FailureType = ResponseFailure
    }
}
