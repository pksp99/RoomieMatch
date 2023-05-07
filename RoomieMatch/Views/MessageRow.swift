//
//  MessageRow.swift
//  RoomieMatch
//
//  Created by Preet Karia on 5/6/23.
//

import SwiftUI

struct MessageRow: View {
    let id: String
    let message: Message
    let isSelf: Bool
    
    
    var body: some View {
        HStack {
            
            // Other Message Row
            if !isSelf {
                VStack(alignment: .leading){
                    // Other User Name
                    Text(message.senderName ?? "Unknown User")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 4)
                        .padding(.vertical, -6)
                    
                    // Other user message text
                    Text(message.text)
                        .padding(8)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    
                }
                Spacer()
            }
            
            // User Message Row
            else {
                Spacer()
                VStack(alignment: .leading){

                    // User message Text
                    Text(message.text)
                        .padding(8)
                        .background(Color("SecondaryAccentColor"))
                        .opacity(0.9)
                        .foregroundColor(Color("AlmostBlackColor"))
                        .cornerRadius(8)
                    
                }
            }
        }
        .padding()
    }
}

struct MessageRow_Previews: PreviewProvider {
    static var previews: some View {
        MessageRow(id: "id", message: Message(id: "123", text: "Hey.. How are you doing", senderId: "user-1", senderName: "Preet", timeStamp: Date()), isSelf: true)
    }
}
