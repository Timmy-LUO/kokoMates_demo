//
//  UserResponseModel.swift
//  kokoMates-demo
//
//  Created by ZHI on 2024/12/27.
//

public struct UserResponseModel: Decodable {
    public let response: [UserDataModel]
}

public struct UserDataModel: Decodable {
    public let name: String
    public let kokoid: String
    
    public func toUiModel() -> UserUiModel {
        UserUiModel(userName: name, userId: kokoid)
    }
}
