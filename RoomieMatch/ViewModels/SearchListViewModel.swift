//
//  SearchListViewModel.swift
//  RoomieMatch
//
//  Created by Preet Karia on 4/28/23.
//

import Foundation


class SearchListViewModel: ObservableObject {
    
    @Published var userGroups: [UserGroup] = dummyGetUserGroupsResponse.userGroups
    
    private var getUserGroupsResponse: GetUserGroupsResponse?
    
    func getUserGroups() {
        let url = USERS_ENDPOINT
        //Network call
        NetworkRequester.shared.downloadJson(url: url, type: GetUserGroupsResponse.self) { result in
            print("GetUserGroupsResponse JSON download and Decode successful")
            self.getUserGroupsResponse = result
            self.userGroups = self.getUserGroupsResponse!.userGroups
        }
    }
}
