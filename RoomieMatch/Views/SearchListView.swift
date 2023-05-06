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
        if (viewModel.userGroups.count == 0) {
            Text("No Roommates available")
        }
        else {
            ScrollView {
                VStack {
                    ForEach(viewModel.userGroups, id: \.groupId) { group in
                        VStack {
                            GroupCardsView(users: group.users)
                                .frame(height: 300)
                            
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
                                    if(viewModel.likedGroups.contains(group.groupId)) {
                                        Button(action: {
                                            viewModel.unLikeGroup(group: group)
                                        }, label: {
                                            Label("Unlike", systemImage: "heart.fill")
                                        }).padding(.horizontal)
                                    }
                                    else {
                                        Button(action: {
                                            viewModel.likeGroup(group: group)
                                        }, label: {
                                            Label("Like", systemImage: "heart")
                                        }).padding(.horizontal)
                                    }
                                    
                                    Spacer()
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
