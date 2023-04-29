//
//  SearchListViewModel.swift
//  RoomieMatch
//
//  Created by Preet Karia on 4/28/23.
//

import Foundation


class SearchListViewModel: ObservableObject {
    static let userGroup = UserGroup(groupId: "10")
    static let userGroup2 = UserGroup(groupId: "110")
    @Published var userGroups: [UserGroup] = [userGroup, userGroup2]
    
    private var getUserGroupsResponse: GetUserGroupsResponse?
}
