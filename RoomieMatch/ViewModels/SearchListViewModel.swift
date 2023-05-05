//
//  SearchListViewModel.swift
//  RoomieMatch
//
//  Created by Preet Karia on 4/28/23.
//

import Foundation
import Firebase


class SearchListViewModel: ObservableObject {
    
    @Published var userGroups: [UserGroup] = dummyGetUserGroupsResponse.userGroups
    
    @Published var likedGroups: [String] = []
    
    private var getUserGroupsResponse: GetUserGroupsResponse?
    
    let db = Firestore.firestore()
    
    func getUserGroups() {
        let url = USERS_ENDPOINT
        //Network call
        NetworkRequester.shared.getRequest(url: url, responseType: GetUserGroupsResponse.self) { result in
            
            switch result {
            case .success(let responseData):
                print("GetUserGroupsResponse JSON download and Decode successful")
                self.getUserGroupsResponse = responseData
                self.userGroups = self.getUserGroupsResponse!.userGroups
            case .failure(_):
                print("Error getting userGroup from \(url)")
            }
        }
    }
    
    func getLikedGroups() {
        let url = LIKE_USER_ENDPOINT
        NetworkRequester.shared.getRequest(url: url, responseType: GroupList.self) { result in
            
            switch result {
            case .success(let groupList):
                print("Received all liked groups for user")
                self.likedGroups = []
                groupList.groups.forEach { group in
                    self.likedGroups.append(group.groupId)
                }
            case .failure(_):
                print("Error getting liked groups: \(url)")
            }

        }
    }
    
    func dismissGroup(group: UserGroup) {
        self.userGroups.removeAll(where: { $0.groupId == group.groupId})
        let url = "\(DISMISS_USER_ENDPOINT)/\(group.groupId)"
        NetworkRequester.shared.postRequestWithNoBody(url: url, responseType: EmptyResponse.self) { result in
            switch result {
            case .success(_):
                print("Dismiss Success")
            case .failure(_):
                print("Dismiss failed \(url)")
            }
        }
    }
    
    func likeGroup(group: UserGroup) {
        self.likedGroups.append(group.groupId)
        let url = "\(LIKE_USER_ENDPOINT)/\(group.groupId)"
        NetworkRequester.shared.postRequestWithNoBody(url: url, responseType: LikeResponse.self) { result in
            switch result {
            case .success(let likeResponse):
                print("Like Success")
                if likeResponse.mutualLike, let chatGroup = likeResponse.group {
                    self.addChat(group: chatGroup)
                }
            case .failure(_):
                print("Like failed \(url)")
            }
        }
    }
    
    func unLikeGroup(group: UserGroup) {
        self.likedGroups.removeAll(where: {$0 == group.groupId})
        let url = "\(DISLIKE_USER_ENDPOINT)/\(group.groupId)"
        NetworkRequester.shared.postRequestWithNoBody(url: url, responseType: EmptyResponse.self) { result in
            switch result {
            case .success(_):
                print("dislike Success")
            case .failure(_):
                print("dislike failed \(url)")
            }
        }
    }
    
    func addChat(group:  LikeResponseGroup) {
        var chat = Chat(id: UUID().uuidString, names: group.userNames, userIds: group.userIds, lastUpdated: Date(), messages: [])
        let ref = db.collection("chats").document(chat.id)
        ref.setData([
            "id": chat.id,
            "names": chat.names,
            "userIds": chat.userIds,
            "lastUpdated": chat.lastUpdated,
            "messages": chat.messages.map { message in
                return [
                    "id": message.id,
                    "text": message.text,
                    "senderId": message.senderId,
                    "senderName": message.senderName,
                    "timeStamp": message.timeStamp
                ] as [String : Any]
            }
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(chat.id)")
            }
        }
    }

}
