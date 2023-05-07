//
//  UserCard.swift
//  RoomieMatch
//
//  Created by Preet Karia on 4/10/23.
//

import SwiftUI

struct UserCard: View {
    @State var user: User
    @State var profileImage: UIImage? = UIImage(named: "defaultProfile")
    
    var id: Int
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("BackgroundColor"))
                .shadow(radius: 5)
                .frame(width: 280, height: 280)
            
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    
                    // Profile image
                    Image(uiImage: profileImage ?? UIImage(named: "defaultProfile")!)
                        .resizable()
                        .scaledToFill()
                        .frame(maxHeight: geometry.size.height/2.2)
                        .clipped()
                    
                    // Card Content
                    VStack(alignment: .leading) {
                        HStack {
                            // Tag 1
                            Text("Free to Connect")
                                .font(.caption)
                                .textCase(.uppercase)
                                .foregroundColor(Color("AlmostBlackColor"))
                                .padding(6.0)
                                .background(
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.accentColor.opacity(0.7))
                                        .frame(height: 20)
                                )
                            Spacer()
                            
                            // Tag 2
                            // Fetching it dynamically
                            Text(getCardTag(attribute: user.userAttributes))
                                .font(.caption)
                                .textCase(.uppercase)
                                .foregroundColor(Color("AlmostBlackColor"))
                                .padding(6.0)
                                .background(
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color("AccentColor").opacity(0.37))
                                        .frame(height: 20)
                                )
                        }
                        
                        // User Name
                        Text(user.userAttributes.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                        // User Intro
                        Text(user.userAttributes.intro)
                            .font(.caption)
                            .foregroundColor(.black)
                            
                       
                        HStack{
                            VStack(alignment: .leading){
                                
                                // User Budget
                                Text("Budget")
                                    .font(.subheadline)
                                Text("$ \(user.userAttributes.monthlyBudget)")
                                    .foregroundColor(Color("DarkGray"))
                                
                            }
                            Spacer()
                            VStack(alignment: .leading){
                                
                                // User Course Details
                                Text("Course")
                                    .font(.subheadline)
                                Text(user.userAttributes.major.rawValue)
                                    .font(.caption)
                                    .foregroundColor(Color("DarkGray"))
                            }
                        }
                        .padding(.vertical, 3)
                        
                    }
                    .padding(.top, 4)
                    .padding(.horizontal)
                    
                    
                }
                
            }
            .cornerRadius(10)
            
        }
        .frame(width: 280, height: 280)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.accentColor, lineWidth: 1)
        )
        .onAppear {
            
            // Download image when from firebase when loaded.
            NetworkRequester.shared.downloadImage(url: user.userAttributes.profileImage) { image in
                self.profileImage = image
            }
        }
        .id(id)
    }
    
    // Function to get user tag based on petFriendly, smoking and party.
    func getCardTag(attribute: UserAttributes) -> String {
        if (attribute.petFriendly == true) {
            return("LOVES PETS")
        }
        else if (attribute.partying == true) {
            return("PARTY PERSON")
        }
        else if (attribute.smoking == false) {
            return("NON SMOKER")
        }
        return("NEW HERE")
    }
}


struct UserCard_Previews: PreviewProvider {
    static var previews: some View {
        UserCard(user: dummyGetUserGroupsResponse.userGroups[0].users[0], id: 0)
    }
}
