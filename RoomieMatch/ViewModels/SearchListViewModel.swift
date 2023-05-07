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
                DispatchQueue.main.async {
                    self.userGroups = self.getUserGroupsResponse!.userGroups
                }
                
                self.getLikedGroups()
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
                print(likeResponse)
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

    private func getConcatId (groupIds: [String]) -> String {
        let temp = groupIds.sorted()
        var str = ""
        temp.forEach{ str += $0}
        return str
    }
}
