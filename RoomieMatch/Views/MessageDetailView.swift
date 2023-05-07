//
//  MessageDetailView.swift
//  RoomieMatch
//
//  Created by Preet Karia on 5/5/23.
//

import SwiftUI
import Firebase

struct MessageDetailView: View {
    @State var messages = [Message]()
    @State var newMessage = ""
    @State var lastMessageId = ""
    var chatId = "jfkdal"
    @EnvironmentObject var appState: AppState
    let ref = Database.database().reference().child("messages")
    let db = Firestore.firestore()
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {                     ForEach(messages, id: \.id) { message in
                        
                        MessageRow(id: message.id, message: message, isSelf: message.senderId == appState.userId)
                    }
                    .onChange(of: lastMessageId) { id in
                        withAnimation {
                            proxy.scrollTo(id, anchor: .bottom)
                        }
                    }
                    .onAppear() {
                        withAnimation {
                            proxy.scrollTo(messages.last?.id, anchor: .bottom)
                        }
                    }
                }
                
            }
            HStack {
                TextField("Type your message...", text: $newMessage)
                    .frame(minHeight: 40)
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .overlay(
                        HStack {
                            Spacer()
                            Button(action: { newMessage = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                            .padding(.trailing, 8)
                    )
                
                Button(action: sendMessage) {
                    Text("Send")
                }
                .padding(.horizontal)
                .disabled(newMessage.isEmpty)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .onAppear(perform: fetchMessages)
    }
    func fetchMessages() {
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
    func sendMessage() {
        
        let id = UUID().uuidString
        let messagesRef = db.collection("chats").document(chatId).collection("messages")
        let message = ["text": newMessage, "senderId": appState.userId!, "timeStamp": Date(), "senderName": appState.userName!, "id": id] as [String : Any]
        
        let messageRef = messagesRef.document(id)
        messageRef.setData(message) { (error) in
            if let error = error {
                print("Error sending message: \(error)")
            } else {
                print("Message sent successfully with ID \(id)")
                db.collection("chats").document(chatId).updateData([
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
struct MessageDetailView_Previews: PreviewProvider {
    // Just for Preview
    static func getAppState() -> AppState {
        
        let appState = AppState(isOnboarded: true, userId: "user1", userName: "Preet Karia", profileImage: UIImage(named: "defaultProfile"), userEmail: "hey@gmail.com")
        return appState
        
    }
    
    static var previews: some View {
        MessageDetailView(messages: [
            Message(id: "1", text: "Hey, how are you?", senderId: "user1", senderName: "John", timeStamp: Date()),
            Message(id: "2", text: "Did you watch the game last night?", senderId: "user1", senderName: "John", timeStamp: Date()),
            Message(id: "3", text: "Are you free for lunch today?", senderId: "user1", senderName: "John", timeStamp: Date()),
            Message(id: "4", text: "I'm doing well, thanks for asking. How about you?", senderId: "user2", senderName: "Sarah", timeStamp: Date()),
            Message(id: "5", text: "No, I didn't get a chance to watch it. Who won?", senderId: "user2", senderName: "Sarah", timeStamp: Date()),
            Message(id: "6", text: "Sorry, I'm not free for lunch today. How about tomorrow?", senderId: "user1", senderName: "Mike", timeStamp: Date()),
            Message(id: "7", text: "Hey, have you seen the new movie that just came out?", senderId: "user4", senderName: "Emily", timeStamp: Date())
        ]
        ).environmentObject(getAppState())
    }
}
