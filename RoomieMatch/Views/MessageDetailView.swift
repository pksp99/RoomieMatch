//
//  MessageDetailView.swift
//  RoomieMatch
//
//  Created by Preet Karia on 5/5/23.
//

import SwiftUI
import Firebase

struct MessageDetailView: View {
    var chatId = "jfkdal"
    @EnvironmentObject var appState: AppState
    
    @ObservedObject var viewModel = MessageDetailViewModel()
    
    var chatName = "Chat Name"
    
    
    var body: some View {
        VStack {
            // Chat Name
            Text(chatName)
                .font(.title)
            ScrollViewReader { proxy in
                ScrollView {
                    
                    ForEach(viewModel.messages, id: \.id) { message in
                        
                        MessageRow(id: message.id, message: message, isSelf: message.senderId == appState.userId)
                    }
                    .onChange(of: viewModel.lastMessageId) { id in
                        withAnimation {
                            proxy.scrollTo(id, anchor: .bottom)
                        }
                    }
                    .onAppear() {
                        withAnimation {
                            proxy.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                        }
                    }
                }
                
            }
            HStack {
                // Space for typing the message
                TextField("Type your message...", text: $viewModel.newMessage)
                    .frame(minHeight: 40)
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .overlay(
                        HStack {
                            Spacer()
                            Button(action: { viewModel.newMessage = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                            .padding(.trailing, 8)
                    )
                // send button
                Button(action: {
                    viewModel.sendMessage(chatId: chatId, userName: appState.userName!, senderId: appState.userId!)
                    
                }) {
                    Text("Send")
                }
                .padding(.horizontal)
                .disabled(viewModel.newMessage.isEmpty)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .onAppear(perform: {
            viewModel.fetchMessages(chatId: chatId)
        })
    }
    
}
struct MessageDetailView_Previews: PreviewProvider {
    
    
    // Just for Preview
    static func getAppState() -> AppState {
        
        let appState = AppState(isOnboarded: true, userId: "user1", userName: "Preet Karia", profileImage: UIImage(named: "defaultProfile"), userEmail: "hey@gmail.com")
        return appState
        
    }
    
    static func getMessages() -> [Message] {
        return [
            Message(id: "1", text: "Hey, how are you?", senderId: "user1", senderName: "John", timeStamp: Date()),
            Message(id: "2", text: "Did you watch the game last night?", senderId: "user1", senderName: "John", timeStamp: Date()),
            Message(id: "3", text: "Are you free for lunch today?", senderId: "user1", senderName: "John", timeStamp: Date()),
            Message(id: "4", text: "I'm doing well, thanks for asking. How about you?", senderId: "user2", senderName: "Sarah", timeStamp: Date()),
            Message(id: "5", text: "No, I didn't get a chance to watch it. Who won?", senderId: "user2", senderName: "Sarah", timeStamp: Date()),
            Message(id: "6", text: "Sorry, I'm not free for lunch today. How about tomorrow?", senderId: "user1", senderName: "Mike", timeStamp: Date()),
            Message(id: "7", text: "Hey, have you seen the new movie that just came out?", senderId: "user4", senderName: "Emily", timeStamp: Date())
        ]
    }
    
    static func getViewModel() -> MessageDetailViewModel {
        let viewModel = MessageDetailViewModel()
        viewModel.messages = getMessages()
        return viewModel
    }
    
    static var previews: some View {
        MessageDetailView(viewModel: getViewModel()).environmentObject(getAppState())
    }
}
