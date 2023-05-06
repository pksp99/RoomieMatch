//
//  AccountsViewModel.swift
//  RoomieMatch
//
//  Created by Preet Karia on 5/5/23.
//

import Foundation
import Firebase
import FirebaseStorage


class AccountsViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var intro: String = ""
    @Published var monthlyBudet: String = "500"
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
    
    
    
    
    var user: User?
    
    
    func validate() -> Bool{
        let failure = name.isEmpty || intro.isEmpty || monthlyBudet.isEmpty
        return !failure
    }
    
    func getUserDetail(userId: String, completed: @escaping (User)->()) {
        let url = "\(USERS_ENDPOINT)/\(userId)"
        
        NetworkRequester.shared.getRequest(url: url, responseType: User.self) { result in
            
            switch result {
            case .success(let responseData):
                print("User JSON download and Decode successful")
                self.user = responseData
                completed(responseData)
                self.mapUserData()
            case .failure(_):
                print("Error getting User from \(url)")
            }
        }
    }
    
    private func mapUserData() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let user = self.user {
            name = user.userAttributes.name
            intro = user.userAttributes.intro
            monthlyBudet = String(user.userAttributes.monthlyBudget)
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
        let httpsRegex = #"^https?:\/\/firebasestorage\.googleapis\.com(:\d+)?\/v\d\/b\/([\w-]+)\.appspot\.com\/o\/(.+)\?alt=media&token=(.+)$"#
        let gsMatch = url.range(of: gsRegex, options: .regularExpression)
        let httpsMatch = url.range(of: httpsRegex, options: .regularExpression)
        return (gsMatch != nil) || (httpsMatch != nil)
    }

    
    
    func postUserDetail(userId: String, email: String) {
        var profileImageURL: String = ""
        
        self.setUserObject(userId: userId, email: email)
        let imageRef = Storage.storage().reference().child("images/\(userId).jpg")
        imageRef.downloadURL{ (url, error) in
            guard let downloadURL = url else {
                print("Some error occurred while geting download url")
                let url = USERS_ENDPOINT
                NetworkRequester.shared.postRequest(url: url, parameters: nil, requestBody: self.user, responseType: EmptyResponse.self){ result in }
                return
            }
            print("Image URL obtained: \(downloadURL)")
            profileImageURL = downloadURL.absoluteString
            self.user?.userAttributes.profileImage = profileImageURL
//            print(self.user!.userAttributes)
            let url = USERS_ENDPOINT
            NetworkRequester.shared.postRequest(url: url, parameters: nil, requestBody: self.user, responseType: EmptyResponse.self){ result in }
            
        }
        if let imageData = self.profileImage?.jpegData(compressionQuality: 0.8) {
            imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    print("Error uploading image: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
            }
        }
    }
    
    func setUserObject(userId: String, email: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var userAttribute = UserAttributes(name: self.name, intro: self.intro, profileImage: "", gender: self.gender, monthlyBudget: Int(self.monthlyBudet) ?? 500, major: self.major, dateAvailable: dateFormatter.string(from: self.dateAvailable), coverImages: [], cleanliness: self.cleanliness, sleepSchedule: self.sleepSchedule)
        userAttribute.smoking = smoking
        userAttribute.partying = partying
        userAttribute.petFriendly = petFriendly
        userAttribute.bio = bio
        userAttribute.foodPreference = foodPreference
        if self.user != nil {
            self.user?.userAttributes = userAttribute
        }
        else {
            self.user = User(userId: userId, email: email, groupId: UUID().uuidString, userAttributes: userAttribute)
        }
    }
}
