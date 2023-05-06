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
                    
                    }
                    .onAppear {
                        viewModel.getAllChats()
                    }
                    .background(Color("BackgroundColor"))
                .scrollContentBackground(.hidden)
                
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
            userIds: ["user-1", "user-2"],
            lastUpdated: Date(),
            messages: []
        ),Chat(
            id: "chat-456",
            names: ["Preet Karia", "Emily", "Karan"],
            userIds: ["user-3", "user-4", "user-5"],
            lastUpdated: Date(),
            messages: []
        )]
        return viewModel
        
    }
    
    
    static var previews: some View {
        MessagesView(viewModel: getViewModel()).environmentObject(getAppState())
    }
}
