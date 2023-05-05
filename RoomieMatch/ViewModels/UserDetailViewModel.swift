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
    
    @Published var name: String = ""
    @Published var intro: String = ""
    @Published var monthlyBudget: String = "500"
    @Published var gender: UserAttributes.Gender = UserAttributes.Gender.male
    @Published var major: UserAttributes.Major = UserAttributes.Major.engineering
    @Published var dateAvailable: Date = Date()
    @Published var foodPreference: UserAttributes.FoodPreference = UserAttributes.FoodPreference.noPreference
    @Published var bio: String = ""
    @Published var cleanliness: Int = 0
    @Published var sleepSchedule: UserAttributes.SleepSchedule = UserAttributes.SleepSchedule.earlyBird
    @Published var smoking: Bool = false
    @Published var partying: Bool = false
    @Published var petFriendly: Bool = false
    @Published var profileImage: UIImage? = UIImage(named: "defaultProfile")
    
    
    
    
    var user: User? {
        didSet {
            mapUserData()
        }
    }
    
    private func mapUserData() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let user = self.user {
            name = user.userAttributes.name
            intro = user.userAttributes.intro
            monthlyBudget = String(user.userAttributes.monthlyBudget)
            gender = user.userAttributes.gender
            major = user.userAttributes.major
            dateAvailable = dateFormatter.date(from: user.userAttributes.dateAvailable) ?? Date()
            foodPreference = user.userAttributes.foodPreference ?? .noPreference
            bio = user.userAttributes.bio ?? ""
            cleanliness = user.userAttributes.cleanliness
            sleepSchedule = user.userAttributes.sleepSchedule
            smoking = user.userAttributes.smoking ?? false
            partying = user.userAttributes.partying ?? false
            petFriendly = user.userAttributes.petFriendly ?? false
            
            let imageURLString = user.userAttributes.profileImage
            if isFirebaseStorageURL(imageURLString) {
                let storageRef = Storage.storage().reference(forURL: imageURLString)
                
                storageRef.getData(maxSize: 10 * 1024 * 1024) { (data, error) -> Void in
                    if let error = error {
                        print("Unable to get the image: \(error)")
                    }
                    self.profileImage = UIImage(data: data!)
                }
            }
            else {
                print("Invalid URL for FirebaseStorage: \(imageURLString)")
            }
        }
    }
    private func isFirebaseStorageURL(_ url: String) -> Bool {
        let gsRegex = #"^gs:\/\/([\w-]+\.appspot\.com)\/(.+)$"#
        let httpsRegex = #"^https:\/\/firebasestorage\.googleapis\.com\/v\d\/b\/([\w-]+)\/o\/(.+)$"#
        let gsMatch = url.range(of: gsRegex, options: .regularExpression)
        let httpsMatch = url.range(of: httpsRegex, options: .regularExpression)
        return (gsMatch != nil) || (httpsMatch != nil)
    }

}
