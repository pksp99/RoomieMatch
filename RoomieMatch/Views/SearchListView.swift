//
//  SearchListView.swift
//  RoomieMatch
//
//  Created by Preet Karia on 4/28/23.
//

import SwiftUI

struct SearchListView: View {
    @ObservedObject var viewModel = SearchListViewModel()
    var body: some View {
        
        // Default view if no users available.
        if (viewModel.userGroups.count == 0) {
            Text("No Roommates available")
        }
        else {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.userGroups, id: \.groupId) { group in
                        VStack {
                            
                            // if single user, show single card view
                            if(group.users.count == 1) {
                                NavigationLink(destination: UserDetailView(user: group.users[0])) {
                                    UserCard(user: group.users[0], id: 0)
                                }
                            }
                            
                            // if multiple users, show group card view.
                            else {
                                GroupCardsView(users: group.users)
                                    .frame(height: 300)
                            }
                            
                            // Like and Dismiss button
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color("BackgroundColor"))
                                    .shadow(radius: 5)
                                    .frame(width: 280, height: 40)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.accentColor, lineWidth: 1)
                                    )
                                HStack {
                                    
                                    // if already liked, then show unlike button
                                    if(viewModel.likedGroups.contains(group.groupId)) {
                                        
                                        // unlike button
                                        Button(action: {
                                            viewModel.unLikeGroup(group: group)
                                        }, label: {
                                            Label("Unlike", systemImage: "heart.fill")
                                        }).padding(.horizontal)
                                    }
                                    else {
                                        // like button
                                        Button(action: {
                                            viewModel.likeGroup(group: group)
                                        }, label: {
                                            Label("Like", systemImage: "heart")
                                        }).padding(.horizontal)
                                    }
                                    
                                    Spacer()
                                    
                                    // dismiss button
                                    Button(action: {
                                        withAnimation{
                                            viewModel.dismissGroup(group: group)
                                        }
                                    }, label: {
                                        Label("Dismiss", image: "ic-dismiss")
                                    })
                                    .padding(.horizontal)
                                }
                                .frame(width: 280, height: 40)
                                
                            }
                        }
                        .padding(.vertical, 20)
                    }
                    
                }
            }
            .navigationTitle("Search")
            .background(Color("BackgroundColor"))
            .onAppear() {
                viewModel.getUserGroups()
            }
        }
        
    }
}

struct SearchListView_Previews: PreviewProvider {
    
    static var previews: some View {
        SearchListView()
    }
}
