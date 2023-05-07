//
//  SearchListViewModel.swift
//  RoomieMatch
//
//  Created by Preet Karia on 4/28/23.
//

import Foundation
import Firebase


class SearchListViewModel: ObservableObject {
    // user group displayed, initializing it dummy group so that something might visible if backend server is not running or unable to connect to server
    @Published var userGroups: [UserGroup] = dummyGetUserGroupsResponse.userGroups
    
    // all likes made by current user.
    @Published var likedGroups: [String] = []
    
    private var getUserGroupsResponse: GetUserGroupsResponse?
    
    let db = Firestore.firestore()
    
    
    // get usergroup details from backend.
    func getUserGroups() {
        let url = USERS_ENDPOINT
        //Network call
        NetworkRequester.shared.getRequest(url: url, responseType: GetUserGroupsResponse.self) { result in
            
            switch result {
            case .success(let responseData):
                print("GetUserGroupsResponse JSON download and Decode successful")
                self.getUserGroupsResponse = responseData
                DispatchQueue.main.async {
                    self.userGroups = self.getUserGroupsResponse!.userGroups
                }
                
                self.getLikedGroups()
            case .failure(_):
                print("Error getting userGroup from \(url)")
            }
        }
    }
    
    // get liked groups from current user in backend
    func getLikedGroups() {
        let url = LIKE_USER_ENDPOINT
        NetworkRequester.shared.getRequest(url: url, responseType: GroupList.self) { result in
            
            switch result {
            case .success(let groupList):
                print("Received all liked groups for user")
                DispatchQueue.main.async {
                    self.likedGroups = []
                    groupList.groups.forEach { group in
                        self.likedGroups.append(group.groupId)
                    }
                    print(self.likedGroups)
                }
                
            case .failure(_):
                print("Error getting liked groups: \(url)")
            }

        }
    }
    // dismiss a group from search view.
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
    
    // like group
    func likeGroup(group: UserGroup) {
        self.likedGroups.append(group.groupId)
        let url = "\(LIKE_USER_ENDPOINT)/\(group.groupId)"
        NetworkRequester.shared.postRequestWithNoBody(url: url, responseType: LikeResponse.self) { result in
            switch result {
            case .success(let likeResponse):
                print("Like Success")
                print(likeResponse)
                if likeResponse.mutualLike, let chatGroup = likeResponse.group {
                    self.addChat(group: chatGroup)
                }
            case .failure(_):
                print("Like failed \(url)")
            }
        }
    }
    
    // Unlike group
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
    
    // If there is a mutual like between two groups, we add chat for them.
    func addChat(group: LikeResponseGroup) {
        let chatId = getConcatId(groupIds: group.groupIds)
        var chat = Chat(id: chatId, names: group.userNames, userIds: group.userIds, groupIds: group.groupIds, lastUpdated: Date(), messages: [])
    
        
        let docRef = db.collection("chats").document(chatId)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Document Already exists, no need to change/create it.
                print("Document data: \(document.data()!)")
            } else {
                // Document does not exist, then create it.
                docRef.setData([
                    "id": chat.id,
                    "names": chat.names,
                    "userIds": chat.userIds,
                    "groupIds": chat.groupIds,
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
    }

    // concat groupId strings to create a new chatId, this is two make sure no two groups have duplicate chats
    private func getConcatId (groupIds: [String]) -> String {
        let temp = groupIds.sorted()
        var str = ""
        temp.forEach{ str += $0}
        return str
    }
}
