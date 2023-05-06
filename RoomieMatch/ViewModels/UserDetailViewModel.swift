//
//  UserDetailViewModel.swift
//  RoomieMatch
//
//  Created by Preet Karia on 5/5/23.
//

import Foundation
import UIKit
import FirebaseStorage


class UserDetailViewModel: ObservableObject {
    
    @Published var profileImage: UIImage = UIImage(named: "defaultProfile")!
    
    
    func getProfileImage(imageURLString: String) {
        if isFirebaseStorageURL(imageURLString) {
            let storageRef = Storage.storage().reference(forURL: imageURLString)
            
            storageRef.getData(maxSize: 10 * 1024 * 1024) { (data, error) -> Void in
                if let error = error {
                    print("Unable to get the image: \(error)")
                }
                self.profileImage = UIImage(data: data!) ?? UIImage(named: "defaultProfile")!
            }
        }
        else {
            print("Invalid URL for FirebaseStorage: \(imageURLString)")
        }
    }
    
    private func isFirebaseStorageURL(_ url: String) -> Bool {
        let gsRegex = #"^gs:\/\/([\w-]+\.appspot\.com)\/(.+)$"#
        let httpsRegex = #"^https?:\/\/firebasestorage\.googleapis\.com(:\d+)?\/v\d\/b\/([\w-]+)\.appspot\.com\/o\/(.+)\?alt=media&token=(.+)$"#
        let gsMatch = url.range(of: gsRegex, options: .regularExpression)
        let httpsMatch = url.range(of: httpsRegex, options: .regularExpression)
        return (gsMatch != nil) || (httpsMatch != nil)
    }
    
    func getSleepSchedule(sleepSchedule: UserAttributes.SleepSchedule) -> String {
        switch sleepSchedule {
        case .earlyBird:
            return "Early Bird"
        case .nightOwl:
            return "Night Owl"
            
        case .somewhereInBetween:
            return "Somewhere In Between"
        }
    }
    
}
