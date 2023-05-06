//
//  MyGroupView.swift
//  RoomieMatch
//
//  Created by Preet Karia on 5/6/23.
//

import SwiftUI



struct MyGroupView: View {
    
    @State var group: UserGroup?
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            VStack {
                if let group = group {
                    Text("Hello " + (appState.userName ?? ""))
                        .font(.title)
                        .padding()
                        
                    if(group.users.count == 1) {
                        NavigationLink(destination: UserDetailView(user: group.users[0])) {
                            UserCard(user: group.users[0], id: 0)
                        }
                    }
                    else {
                        GroupCardsView(users: group.users)
                            .frame(height: 300)
                    }
                }
            }.onAppear{
                let url = GET_USER_GROUP
                NetworkRequester.shared.getRequest(url: url, responseType: UserGroup.self) { result in
                    switch result {
                    case .success(let userGroup):
                        self.group = userGroup
                    case .failure(_):
                        print("Error getting the user group")
                    }
                }
            }
            
        }
    }
}

struct MyGroupView_Previews: PreviewProvider {
    static var previews: some View {
        MyGroupView()
    }
}
