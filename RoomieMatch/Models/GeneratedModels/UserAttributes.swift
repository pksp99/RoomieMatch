//
// UserAttributes.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct UserAttributes: Codable {

    public enum Gender: String, Codable, CaseIterable {
        case male = "male"
        case female = "female"
        case other = "other"
    }
    public enum Major: String, Codable, CaseIterable {
        case businessAdministration = "Business Administration"
        case computerScience = "Computer Science"
        case psychology = "Psychology"
        case nursing = "Nursing"
        case education = "Education"
        case biology = "Biology"
        case engineering = "Engineering"
        case communications = "Communications"
        case politicalScience = "Political Science"
        case englishLiterature = "English Literature"
        case mathematics = "Mathematics"
        case history = "History"
        case economics = "Economics"
        case sociology = "Sociology"
        case artAndDesign = "Art and Design"
        case environmentalScienceStudies = "Environmental Science/Studies"
        case marketing = "Marketing"
        case physics = "Physics"
        case chemistry = "Chemistry"
        case foreignLanguagesAndLiteratures = "Foreign Languages and Literatures"
    }
    public enum FoodPreference: String, Codable, CaseIterable {
        case vegetarian = "Vegetarian"
        case vegan = "Vegan"
        case jain = "Jain"
        case glutenFree = "Gluten-Free"
        case noPreference = "No Preference"
    }
    public enum SleepSchedule: String, Codable, CaseIterable { 
        case earlyBird = "early_bird"
        case nightOwl = "night_owl"
        case somewhereInBetween = "somewhere_in_between"
    }
    /** Name of the User */
    public var name: String
    /** A single line of intro for the user. */
    public var intro: String
    /** Link for user&#x27;s profile Image. */
    public var profileImage: String
    /** User&#x27;s gender */
    public var gender: Gender
    /** User&#x27;s age */
    public var age: Int?
    /** Monthly budget of the user. */
    public var monthlyBudget: Int
    /** User&#x27;s major or field of study */
    public var major: Major
    /** Date of availability */
    public var dateAvailable: String
    /** User&#x27;s food preference */
    public var foodPreference: FoodPreference?
    /** Link for user&#x27;s cover images. */
    public var coverImages: [UserAttributesCoverImages]
    /** User&#x27;s bio or description */
    public var bio: String?
    /** User&#x27;s hobbies or interests */
    public var hobbies: [String]?
    /** User&#x27;s cleanliness rating (1&#x3D;very messy, 5&#x3D;very clean) */
    public var cleanliness: Int
    /** User&#x27;s preferred sleep schedule */
    public var sleepSchedule: SleepSchedule
    /** Whether the user smokes or not */
    public var smoking: Bool?
    /** Whether the user likes to party or not */
    public var partying: Bool?
    /** Whether the user is okay with living with pets or not */
    public var petFriendly: Bool?

    public init(name: String, intro: String, profileImage: String, gender: Gender, age: Int? = nil, monthlyBudget: Int, major: Major, dateAvailable: String, foodPreference: FoodPreference? = nil, coverImages: [UserAttributesCoverImages], bio: String? = nil, hobbies: [String]? = nil, cleanliness: Int, sleepSchedule: SleepSchedule, smoking: Bool? = nil, partying: Bool? = nil, petFriendly: Bool? = nil) {
        self.name = name
        self.intro = intro
        self.profileImage = profileImage
        self.gender = gender
        self.age = age
        self.monthlyBudget = monthlyBudget
        self.major = major
        self.dateAvailable = dateAvailable
        self.foodPreference = foodPreference
        self.coverImages = coverImages
        self.bio = bio
        self.hobbies = hobbies
        self.cleanliness = cleanliness
        self.sleepSchedule = sleepSchedule
        self.smoking = smoking
        self.partying = partying
        self.petFriendly = petFriendly
    }

    public enum CodingKeys: String, CodingKey { 
        case name
        case intro
        case profileImage = "profile_image"
        case gender
        case age
        case monthlyBudget = "monthly_budget"
        case major
        case dateAvailable = "date_available"
        case foodPreference = "food_preference"
        case coverImages = "cover_images"
        case bio
        case hobbies
        case cleanliness
        case sleepSchedule = "sleep_schedule"
        case smoking
        case partying
        case petFriendly = "pet_friendly"
    }

}
