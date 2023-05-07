//
//  ContentView.swift
//  RoomieMatch
//
//  Created by Preet Karia on 3/29/23.
//

import SwiftUI



// The appState used through the app for maintaing user info.
class AppState: ObservableObject{
    @Published var isOnboarded: Bool
    
    var userId: String?
    var userName: String?
    var userEmail: String?
    init(isOnboarded: Bool) {
        self.isOnboarded = isOnboarded
    }
    
    init(isOnboarded: Bool, userId: String?, userName: String?, profileImage: UIImage?, userEmail: String?) {
        self.isOnboarded = isOnboarded
        self.userId = userId
        self.userName = userName
        self.userEmail = userEmail
    }
}

struct ContentView: View {
    @ObservedObject var appState = AppState(isOnboarded: false)
    var body: some View {
        if appState.isOnboarded {
            ContentMainView().environmentObject(appState)
        }
        else {
            LoginRegisterView()
                .environmentObject(appState)
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
