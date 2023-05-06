//
//  UserCard.swift
//  RoomieMatch
//
//  Created by Preet Karia on 4/10/23.
//

import SwiftUI

struct UserCard: View {
    @State var user: User
    @ObservedObject var viewModel = UserDetailViewModel()
    var id: Int
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("BackgroundColor"))
                .shadow(radius: 5)
                .frame(width: 280, height: 280)
            
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    Image(uiImage: viewModel.profileImage) //TODO change
                        .resizable()
                        .scaledToFill()
                        .frame(maxHeight: geometry.size.height/2.2)
                        .clipped()
                    
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Free to Connect") // TODO change
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
                            Text("Found a house") // TODO change
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
                        
                        
                        Text(user.userAttributes.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                        
                        Text(user.userAttributes.intro)
                            .font(.caption)
                            .foregroundColor(.black)
                            

                        HStack{
                            VStack(alignment: .leading){
                                Text("Budget")
                                    .font(.subheadline)
                                Text("$ \(user.userAttributes.monthlyBudget)")
                                    .foregroundColor(Color("DarkGray"))
                                
                            }
                            Spacer()
                            VStack(alignment: .leading){
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
            viewModel.getProfileImage(imageURLString: user.userAttributes.profileImage)
        }
        .id(id)
    }
}


struct UserCard_Previews: PreviewProvider {
    static var previews: some View {
        UserCard(user: dummyGetUserGroupsResponse.userGroups[0].users[0], id: 0)
    }
}
