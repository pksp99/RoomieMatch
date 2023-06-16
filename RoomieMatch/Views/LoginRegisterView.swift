//
//  LoginRegisterView.swift
//  RoomieMatch
//
//  Created by Preet Karia on 5/5/23.
//

import SwiftUI

struct LoginRegisterView: View {
    @EnvironmentObject var appState: AppState
    @State var isResgisteredNow = false
    var body: some View {
        if isResgisteredNow {
            AccountView()
        }
        else {
            LoginView(isRegisteredNow: $isResgisteredNow)
        }
    }
}

struct LoginRegisterView_Previews: PreviewProvider {
    
    //Just for preview
    static func getAppState() -> AppState {
        var appState = AppState(isOnboarded: false, userId: "123", userName: "John Doe", profileImage: UIImage(named: "defaultProfile"), userEmail: "hey@gmail.com")
        return appState
    }
    static var previews: some View {
        LoginRegisterView().environmentObject(getAppState())
    }
}
