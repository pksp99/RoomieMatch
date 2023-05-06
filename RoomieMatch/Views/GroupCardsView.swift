//
//  GroupCardsView.swift
//  RoomieMatch
//
//  Created by Preet Karia on 5/1/23.
//

import SwiftUI

struct GroupCardsView: View {
    var users: [User]
    @State private var selectedIndex = 0
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { scrollView in
                HStack(alignment: .center, spacing: 200) {
                    ForEach(0..<users.count) { index in
                        @State var isActive = false
                        
                        GeometryReader { geometry in
                            NavigationLink(destination: UserDetailView(user: users[index])) {
                                UserCard(user: users[index], id: index)
                                    .scaleEffect(
                                        getScale(geometry: geometry, index: index)
                                    )
                                
                                
                            }
                            
                        }
                    }
                    
                    .padding(20)
                    .onAppear {
                        scrollView.scrollTo(selectedIndex, anchor: .center)
                    }
                    .background(GeometryReader { proxy in
                        Color.clear.onAppear {
                            scrollView.scrollTo(selectedIndex, anchor: .center)
                        }
                        .onChange(of: selectedIndex) { index in
                            withAnimation {
                                scrollView.scrollTo(index, anchor: .center)
                            }
                        }
                        .frame(width: proxy.size.width, height: proxy.size.height)
                    })
                    
                    Spacer()
                    Spacer()
                    
                }
            }
            
            
        }
        .onAppear {
            selectedIndex = users.count / 2
        }
    }
    func getScale(geometry: GeometryProxy, index: Int) -> CGFloat {
        let deviceWidth = geometry.size.width
        let cardCenter = geometry.frame(in: .global).midX - 50
        let scale =  1 - abs(deviceWidth / 2 -  cardCenter) / 900
        
        return scale
    }
    
}

struct GroupCardsView_Previews: PreviewProvider {
    static var previews: some View {
        GroupCardsView(users: dummyGetUserGroupsResponse.userGroups[0].users)
    }
}
