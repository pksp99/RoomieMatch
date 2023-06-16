//
//  Message.swift
//  RoomieMatch
//
//  Created by Preet Karia on 5/4/23.
//

import Foundation

struct Message: Identifiable {
    let id: String
    var text: String
    var senderId: String
    var senderName: String
    var timeStamp: Date
}
