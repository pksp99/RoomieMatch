//
//  ContentMainView.swift
//  RoomieMatch
//
//  Created by Preet Karia on 4/28/23.
//

import SwiftUI
import Firebase

struct ContentMainView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        NavigationView {
            TabView {
               
                SearchListView()
                    .tabItem {
                        Image("ic-search")
                            .renderingMode(.template)
                        Text("Search")
                    }
        
                MessagesView()
                    .tabItem {
                        Image("ic-messages")
                            .renderingMode(.template)
                        Text("Messages")
                    }
                AccountView()
                    .tabItem {
                        Image("ic-account")
                            .renderingMode(.template)
                        Text("Accounts")
                    }
            }
            .navigationBarItems(
                leading:
                    Menu {
                        Button(action: {
                            // TODO
                        }, label: {
                            Label("Saved People", systemImage: "star.fill")
                        })
                    } label: {
                        Image(systemName: "line.horizontal.3")
                            .imageScale(.large)
                    },
                trailing:
                    Menu {
                        Button(action: {
                           //TODO User can change account settings, for example changing passwords.
                            
                        }, label: {
                            Label("Account Settings", systemImage: "gear")
                        })
                        
                        Button(action: {
                            signOut()
                            
                        }, label: {
                            Label("Sign out", systemImage: "rectangle.portrait.and.arrow.right")
                        })
                    } label: {
                        Image(systemName: "person.fill")
                    }
            )

        }

    }
    func signOut() {
        do {
            try Auth.auth().signOut()
            appState.isOnboarded = false
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
struct ContentMainView_Previews: PreviewProvider {
    
    //Just for Preview
    static func getAppState() -> AppState {
        
        let appState = AppState(isOnboarded: true, userId: "123", userName: "Preet Karia", profileImage: UIImage(named: "defaultProfile"), userEmail: "hey@gmail.com")
        return appState

    }
    
    static var previews: some View {
        ContentMainView().environmentObject(getAppState())
    }
}
