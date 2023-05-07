//
//  MessageDetailViewModel.swift
//  RoomieMatch
//
//  Created by Preet Karia on 5/7/23.
//

import Foundation
import Firebase

class MessageDetailViewModel: ObservableObject {
    @Published var messages = [Message]()
    @Published var newMessage = ""
    @Published var lastMessageId = ""
    
    let db = Firestore.firestore()
    
    func fetchMessages(chatId: String) {
        let docRef = db.collection("chats").document(chatId)
        
        docRef.getDocument { (document, error) in
            if let document = document {
                docRef.collection("messages").addSnapshotListener { (querySnapshot, error) in
                    print("Fetching")
                    guard let documents = querySnapshot?.documents else {
                        print("No documents found")
                        return
                    }
                    
                    self.messages = documents.compactMap { (document) in
                        let data = document.data()
                        let id = data["id"] as! String
                        let text = data["text"] as! String
                        let senderName = data["senderName"] as! String
                        let senderId = data["senderId"] as! String ?? ""
                        let timeStamp = data["timeStamp"] as! Timestamp
                        let timeStampDate = timeStamp.dateValue()
                        
                        return Message(id: id, text: text, senderId: senderId, senderName: senderName, timeStamp: timeStampDate)
                    }
                    self.messages.sort{$0.timeStamp < $1.timeStamp}
                    if let lastId = self.messages.last?.id {
                        self.lastMessageId = lastId
                    }
                }
            }
            else {
                print("Unable to get messages")
            }
        }
        
    }
    func sendMessage(chatId: String, userName: String, senderId: String) {
        
        let id = UUID().uuidString
        let messagesRef = db.collection("chats").document(chatId).collection("messages")
        let message = ["text": newMessage, "senderId": senderId, "timeStamp": Date(), "senderName": userName, "id": id] as [String : Any]
        
        let messageRef = messagesRef.document(id)
        messageRef.setData(message) { (error) in
            if let error = error {
                print("Error sending message: \(error)")
            } else {
                print("Message sent successfully with ID \(id)")
                self.db.collection("chats").document(chatId).updateData([
                    "lastUpdated": Date()
                ]) { error in
                    if let error = error {
                        print("Error updating document: \(error)")
                    } else {
                        print("Document successfully updated")
                    }
                }
            }
        }
        self.newMessage = ""
        
    }
}
