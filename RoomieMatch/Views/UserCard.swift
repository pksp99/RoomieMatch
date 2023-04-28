//
//  UserCard.swift
//  RoomieMatch
//
//  Created by Preet Karia on 4/10/23.
//

import SwiftUI

struct UserCard: View {
    @State var user: User?
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("BackgroundColor"))
                .shadow(radius: 5)
                .aspectRatio(14/15, contentMode: .fit)
            
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    Image("profileImage")
                        .resizable()
                        .scaledToFill()
                        .frame(maxHeight: geometry.size.height/2.2)
                        .clipped()
                    
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Free to Connect")
                                .font(.caption)
                                .textCase(.uppercase)
                                .padding(6.0)
                                .background(
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.accentColor)
                                        .frame(height: 20)
                                )
                            Spacer()
                            Text("Found a house")
                                .font(.caption)
                                .textCase(.uppercase)
                                .padding(6.0)
                                .background(
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color("AccentColor").opacity(0.37))
                                        .frame(height: 20)
                                )
                        }
                        
                        
                        Text("John Wick")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        
                        Text("Some description")
                            .font(.body)

                        HStack{
                            VStack(alignment: .leading){
                                Text("Budget")
                                    .font(.subheadline)
                                Text("$500")
                                    .foregroundColor(Color("DarkGray"))
                                
                            }
                            Spacer()
                            VStack(alignment: .leading){
                                Text("Course")
                                    .font(.subheadline)
                                Text("Computer Scinece")
                                    .font(.caption)
                                    .foregroundColor(Color("DarkGray"))
                            }
                        }
                        .padding(.vertical)
                        
                    }
                    .padding(.top, 4)
                    .padding(.horizontal)
                    
                    
                }
                
            }
            .aspectRatio(14/15, contentMode: .fit)
            .cornerRadius(10)
            
        }
        .frame(maxWidth: 300)
        .aspectRatio(14/15, contentMode: .fit)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.accentColor, lineWidth: 1)
        )
        .padding()
    }
}


struct UserCard_Previews: PreviewProvider {
    static var previews: some View {
        UserCard()
    }
}
