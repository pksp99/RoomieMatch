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
        ZStack {
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                LazyVStack {
                    ForEach($viewModel.userGroups, id: \.groupId) { userGroup in
                        NavigationLink(destination: UserDetailView()) {
                            UserCard()
                    
                        }
                    }
                }
            }
            
        }
    }
}

struct SearchListView_Previews: PreviewProvider {
    static var previews: some View {
        SearchListView()
    }
}
