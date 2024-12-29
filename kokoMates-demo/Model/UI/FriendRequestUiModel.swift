//
//  FriendRequestUiModel.swift
//  kokoMates-demo
//
//  Created by ZHI on 2024/12/26.
//

public struct FriendRequestUiModel: Hashable {
    public let id: String
    public let userImage: String?
    public let name: String
    public let message: String
    public let status: Int
    public let isTop: String
    public let updateDate: String
}
