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
            
            SwiftUI.Group {
                Text(viewModel.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Introduction")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                Text(viewModel.intro)
                    .font(.body)
                
                Text("Monthly Budget")
                    .font(.headline)
                    .fontWeight(.bold)
                Text("$\(viewModel.monthlyBudget)")
                    .font(.body)
                
                Text("Gender")
                    .font(.headline)
                    .fontWeight(.bold)
                Text(viewModel.gender.rawValue)
                    .font(.body)
            }
            
            SwiftUI.Group {
                
                Text("Major")
                    .font(.headline)
                    .fontWeight(.bold)
                Text(viewModel.major.rawValue)
                    .font(.body)
                
               
                
                Text("Food Preference")
                    .font(.headline)
                    .fontWeight(.bold)
                Text(viewModel.foodPreference.rawValue)
                    .font(.body)
                
                Text("Bio")
                    .font(.headline)
                    .fontWeight(.bold)
                Text(viewModel.bio)
                    .font(.body)
            }
            
            SwiftUI.Group {
                
                Text("Cleanliness")
                    .font(.headline)
                    .fontWeight(.bold)
                Text("\(viewModel.cleanliness) out of 10")
                    .font(.body)
                
                Text("Sleep Schedule")
                    .font(.headline)
                    .fontWeight(.bold)
                Text(viewModel.sleepSchedule.rawValue)
                    .font(.body)
                
                Text("Smoking")
                    .font(.headline)
                    .fontWeight(.bold)
                Text(viewModel.smoking ? "Yes" : "No")
                    .font(.body)
                
                Text("Partying")
                    .font(.headline)
                    .fontWeight(.bold)
                Text(viewModel.partying ? "Yes" : "No")
                    .font(.body)
            }
            
            Text("Pet Friendly")
                .font(.headline)
                .fontWeight(.bold)
            Text(viewModel.petFriendly ? "Yes" : "No")
                .font(.body)
            
            Spacer()
        }
        .onAppear {
            viewModel.user = user
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
