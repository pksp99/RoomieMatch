//
//  UserDetailView.swift
//  RoomieMatch
//
//  Created by Preet Karia on 4/28/23.
//

import SwiftUI

import SwiftUI

struct UserDetailView: View {
    
    @State var user: User
    @State var profileImage: UIImage = UIImage(named: "defaultProfile")!
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 24) {
                
                Image(uiImage: profileImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 350 - 32)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray, lineWidth: 0.5)
                    )
                    .padding(.horizontal, 16)
                
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(user.userAttributes.name)
                        .font(.title)
                    
                    Text(user.userAttributes.intro)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 16)
                
                Divider()
                    .padding(.horizontal, 16)
                
                VStack(alignment: .leading, spacing: 8) {
                    UserFieldView(title: "Monthly Budget", value: "$\(user.userAttributes.monthlyBudget)")
                    UserFieldView(title: "Gender", value: user.userAttributes.gender.rawValue)
                    UserFieldView(title: "Major", value: user.userAttributes.major.rawValue)
                    UserFieldView(title: "Date Available", value: user.userAttributes.dateAvailable)
                    UserFieldView(title: "Food Preference", value: user.userAttributes.foodPreference?.rawValue ?? "No Preference")
                    UserFieldView(title: "Cleanliness", value: "\(user.userAttributes.cleanliness)/5")
                    UserFieldView(title: "Sleep Schedule", value: getSleepSchedule(sleepSchedule: user.userAttributes.sleepSchedule))
                    SwiftUI.Group {
                        UserFieldView(title: "Smoking", value: user.userAttributes.smoking! ? "Yes" : "No")
                        UserFieldView(title: "Partying", value: user.userAttributes.partying! ? "Yes" : "No")
                        UserFieldView(title: "Pet Friendly", value: user.userAttributes.petFriendly! ? "Yes" : "No")
                    }
                    Divider()
                    
                    Text(user.userAttributes.bio ?? "")
                        .font(.body)
                        .padding(.top, 8)
                }
                .padding(.horizontal, 16)
                
                Spacer()
            }
            .onAppear {
                
                NetworkRequester.shared.downloadImage(url: user.userAttributes.profileImage) { image in
                    self.profileImage = image
                }
            }
            
        }
        .background(Color("BackgroundColor"))
        
    }
    
    func getSleepSchedule(sleepSchedule: UserAttributes.SleepSchedule) -> String {
        switch sleepSchedule {
        case .earlyBird:
            return "Early Bird"
        case .nightOwl:
            return "Night Owl"
            
        case .somewhereInBetween:
            return "Somewhere In Between"
        }
    }
}

struct UserFieldView: View {
    
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            Text(value)
                .font(.system(size: 18))
        }
    }
}



struct UserDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        UserDetailView(user: dummyGetUserGroupsResponse.userGroups[0].users[0])
    }
}
