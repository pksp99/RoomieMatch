//
//  Chat.swift
//  RoomieMatch
//
//  Created by Preet Karia on 5/4/23.
//

import Foundation

struct Chat: Identifiable {
    let id: String
    var names: [String]
    var userIds: [String]
    var lastUpdated: Date
    var messages: [Message]
}
