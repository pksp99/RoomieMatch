//
// Group.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct Group: Codable {

    /** Unique group ID. */
    public var groupId: String
    public var groupInfo: String?
    public var userCount: Int
    public var userIds: [String]

    public init(groupId: String, groupInfo: String? = nil, userCount: Int, userIds: [String]) {
        self.groupId = groupId
        self.groupInfo = groupInfo
        self.userCount = userCount
        self.userIds = userIds
    }

    public enum CodingKeys: String, CodingKey { 
        case groupId
        case groupInfo = "group_info"
        case userCount = "user_count"
        case userIds = "user_ids"
    }

}
