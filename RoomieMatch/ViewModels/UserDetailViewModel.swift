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
        NetworkRequester.shared.downloadImage(url: imageURLString) { image in
            self.profileImage = image
        }
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
