//
//  MessagesViewModel.swift
//  RoomieMatch
//
//  Created by Preet Karia on 5/4/23.
//

import Foundation
import Firebase

class MessagesViewModel: ObservableObject {
    @Published var chats: [Chat] = []
    let db = Firestore.firestore()
    
    
    // get all user chats
    func getAllChats(userId: String) {
        db.collection("chats").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting all chats")
            } else {
                self.chats = []
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let id = data["id"] as! String
                    let names = data["names"] as! [String]
                    let userIds = data["userIds"] as! [String]
                    let groupIds = data["groupIds"] as! [String]
                    let timeStamp = data["lastUpdated"] as! Timestamp
                    let lastUpdated = timeStamp.dateValue()
                    let messagesData = data["messages"] as! [[String:Any]]
                    var messages: [Message] = []
                    for messageData in messagesData {
                        let id = messageData["id"] as! String
                        let text = messageData["text"] as! String
                        let senderId = messageData["senderId"] as! String
                        let senderName = messageData["senderName"] as! String
                        let timeStamp = messageData["timeStamp"] as! Date
                        let message = Message(id: id, text: text, senderId: senderId, senderName: senderName, timeStamp: timeStamp)
                        messages.append(message)
                    }
                    let chat = Chat(id: id, names: names, userIds: userIds, groupIds: groupIds, lastUpdated: lastUpdated, messages: messages)
                    self.chats.append(chat)
                }
                self.chats.sort(by: {$0.lastUpdated > $1.lastUpdated})
                print("Received Chats: \(self.chats.count)")
                self.chats = self.chats.filter {$0.userIds.contains(userId)}
                print("Filter Chats: \(self.chats.count)")
            }
        }
    }
    
    // Generated Chat Name
    func getChatName(chat: Chat, userName: String) -> String {
        var names = chat.names
        // Removing user name from all names, thus chat name will display other persons name
        if let index = names.firstIndex(of: userName) {
            names.remove(at: index)
        }
        var nameString = ""
        for name in names {
            nameString = nameString + name + ", "
        }
        return String(nameString.dropLast(2))
    }
    
    // Generate dynamic chat profile image.
    // If it is a two person chat, this gives the image name with the initial of other person
    // Else more then two means, it is group chat, thus gives group symbol.
    func getChatProfileImage(chat: Chat, userName: String) -> String {
        var names = chat.names
        // Removing user name from all names, thus chat name will display other persons name
        if let index = names.firstIndex(of: userName) {
            names.remove(at: index)
        }
        var sysImageName: String
        if names.count == 1, let firstChar = names[0].first{
            sysImageName = "\(firstChar.lowercased()).circle.fill"
        }
        else {
            sysImageName = "person.3.fill"
        }
        return sysImageName
    }
    
    // Send a request to backend to create group.
    func makeGroup(group1: String, group2: String) {
        let url = MAKE_GROUP_ENDPOINT
        print("Making group for \(group1) and \(group2)")
        NetworkRequester.shared.postRequestWithNoBody(url: url, parameters: ["group_id_1": group1, "group_id_2": group2], responseType: EmptyResponse.self) {results in
            
        }
    }
    
    // Generated last Udpdated time "dynamic string" based on lastUpdated time.
    func getLastUpdatedTimeString(for date: Date) -> String {
        let now = Date()
        let secondsSinceUpdate = Int(now.timeIntervalSince(date))
        let minutesSinceUpdate = secondsSinceUpdate / 60
        let hoursSinceUpdate = minutesSinceUpdate / 60
        let daysSinceUpdate = hoursSinceUpdate / 24

        if daysSinceUpdate > 0 {
            return "\(daysSinceUpdate) day\(daysSinceUpdate > 1 ? "s" : "") ago"
        } else if hoursSinceUpdate > 0 {
            return "\(hoursSinceUpdate) hour\(hoursSinceUpdate > 1 ? "s" : "") ago"
        } else if minutesSinceUpdate > 0 {
            return "\(minutesSinceUpdate) minute\(minutesSinceUpdate > 1 ? "s" : "") ago"
        } else {
            return "just now"
        }
    }

}
