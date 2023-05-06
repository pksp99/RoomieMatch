//
//  MessagesView.swift
//  RoomieMatch
//
//  Created by Preet Karia on 4/28/23.
//

import SwiftUI

struct MessagesView: View {
    @ObservedObject var viewModel = MessagesViewModel()
    @EnvironmentObject var appState: AppState
    @State private var showingAlert = false
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
    
                    List(viewModel.chats) { chat in
                         
                            HStack{
                                Image(systemName: viewModel.getChatProfileImage(chat: chat, userName: appState.userName!)).resizable().clipShape(Circle()).frame(width: 50, height: 40)
                                    .foregroundColor(Color("AlmostBlackColor")).opacity(0.7).padding()
                                Text(viewModel.getChatName(chat: chat, userName: appState.userName!))
                                    .font(.title2)
                                Spacer()
                            }
                            .listRowBackground(Color("SecondaryAccentColor"))
                            .contextMenu {
                                Button(action: {
                                    viewModel.makeGroup(group1: chat.groupIds[0], group2: chat.groupIds[1])
                                    showingAlert = true
                                }) {
                                    Text("Make Group")
                                    Image(systemName: "arrow.up.bin.fill")
                                }
                            }
                    
                    }
                    .onAppear {
                        viewModel.getAllChats(userId: appState.userId!)
                    }
                    .background(Color("BackgroundColor"))
                .scrollContentBackground(.hidden)
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Requested to make group"), dismissButton: .default(Text("OK")))
                }
                
        }
    }
}

struct MessagesView_Previews: PreviewProvider {
    
    // Just for Preview
    static func getAppState() -> AppState {
        
        let appState = AppState(isOnboarded: true, userId: "123", userName: "Preet Karia", profileImage: UIImage(named: "defaultProfile"), userEmail: "hey@gmail.com")
        return appState

    }
    static func getViewModel() -> MessagesViewModel {
        var viewModel = MessagesViewModel()
        viewModel.chats = [Chat(
            id: "chat-123",
            names: ["Preet Karia", "Emily"],
            userIds: ["user-1", "user-2"], groupIds: ["group-1", "group-2"],
            lastUpdated: Date(),
            messages: []
        ),Chat(
            id: "chat-456",
            names: ["Preet Karia", "Emily", "Karan"],
            userIds: ["user-3", "user-4", "user-5"], groupIds: ["group-1", "group-3"],
            lastUpdated: Date(),
            messages: []
        )]
        return viewModel
        
    }
    
    
    static var previews: some View {
        MessagesView(viewModel: getViewModel()).environmentObject(getAppState())
    }
}
