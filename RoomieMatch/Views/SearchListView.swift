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
        
//        NavigationView {
            ScrollView {
                VStack {
                    ForEach(viewModel.userGroups, id: \.groupId) { group in
                        VStack {
                            GroupCardsView(users: dummyGetUserGroupsResponse.userGroups[0].users)
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
                                    Button(action: {}, label: {
                                        Label("Save", image: "ic-save-star")
                                    })
                                    .padding(.horizontal)
                                    Spacer()
                                    Button(action: {}, label: {
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
        
//    }
}

struct SearchListView_Previews: PreviewProvider {
    
    static var previews: some View {
        SearchListView()
    }
}
