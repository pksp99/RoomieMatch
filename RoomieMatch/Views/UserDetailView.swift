//
//  UserDetailView.swift
//  RoomieMatch
//
//  Created by Preet Karia on 4/28/23.
//

import SwiftUI

struct UserDetailView: View {
    
    @State var user: User
    @ObservedObject var viewModel = UserDetailViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
       
            Text("Name")
                .font(.headline)
                .fontWeight(.bold)
            Text("\(user.userAttributes.name)")
                .font(.body)
            Text("Monthly Budget")
                .font(.headline)
                .fontWeight(.bold)
            Text("$\(user.userAttributes.monthlyBudget)")
                .font(.body)
        }
        .onAppear {
        
        }
        .padding()
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

struct UserDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        UserDetailView(user: dummyGetUserGroupsResponse.userGroups[0].users[0])
    }
}
