//
//  AccountView.swift
//  RoomieMatch
//
//  Created by Preet Karia on 4/28/23.
//

import SwiftUI
import Combine

struct AccountView: View {
    @ObservedObject var viewModel = AccountsViewModel()
    @State private var showImagePicker = false
    @State private var showingAlert = false
    @State private var selectedImage: UIImage?
    @State var alertText = ""
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            // Zstack layer one
            Form {
                // Personal Information
                Section(header: Text("Personal Information")) {
                    
                    // User Name
                    VStack(alignment: .leading) {
                        HStack {
                            Text("User Name")
                            Text("*").foregroundColor(.accentColor)
                        }
                        TextField("Name", text: $viewModel.name).foregroundColor(Color("DarkGray"))
                            .disableAutocorrection(true)
                    }
                    
                    // User Intro
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Intro")
                            Text("*").foregroundColor(.accentColor)
                        }
                        TextField("Brief one line intro", text: $viewModel.intro)
                            .foregroundColor(Color("DarkGray"))
                    }
                    
                    // Gender
                    Picker(selection: $viewModel.gender, label: Text("Gender")) {
                        ForEach(UserAttributes.Gender.allCases, id: \.self) { preference in
                            Text(preference.rawValue.capitalized).tag(preference)
                        }
                    }
                    
                    // Major
                    Picker(selection: $viewModel.major, label: Text("Major")) {
                        ForEach(UserAttributes.Major.allCases, id: \.self) { preference in
                            Text(preference.rawValue.capitalized).tag(preference)
                        }
                    }
                    
                    // Date Available
                    DatePicker(
                        selection: $viewModel.dateAvailable,
                        in: Date()...,
                        displayedComponents: [.date]
                    ) {
                        Text("Date Available")
                    }
                }
                
                // User Profile Picture
                Section(header: Text("Profile Picture")) {
                    if let image = viewModel.profileImage {
                        HStack(alignment: .center) {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                                .aspectRatio(contentMode: .fit)
                                .background(Color.white)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .shadow(radius: 5)
                                .onTapGesture {
                                    showImagePicker = true
                                }
                            Button(action: {showImagePicker = true}, label: {Text("click to change")}).padding()
                        }
                    }
                    
                }.listRowBackground(Color("BackgroundColor"))
                
                // User Budget
                Section(header: HStack {
                    Text("Budget")
                    Text("*").foregroundColor(.accentColor)
                }) {
                    HStack {
                        Text("$").foregroundColor(.accentColor)
                        TextField("Monthly Budget", text: $viewModel.monthlyBudet)
                            .keyboardType(.numberPad)
                            .foregroundColor(Color("DarkGray"))
                    }
                }
                
                
                // User Bio
                Section(header: Text("Bio")) {TextEditor(text: $viewModel.bio)
                        .frame(height: 100)
                        .cornerRadius(8)
                        .foregroundColor(Color("DarkGray"))
                }
                
                // User Preferences
                Section(header: Text("Preferences")) {
                    
                    // Food Preference
                    Picker(selection: $viewModel.foodPreference, label: Text("Food Preference")) {
                        Text("No Preference").tag(UserAttributes.FoodPreference.noPreference)
                        Text("Vegetarian").tag(UserAttributes.FoodPreference.vegetarian)
                        Text("Vegan").tag(UserAttributes.FoodPreference.vegan)
                        Text("Gluten Free").tag(UserAttributes.FoodPreference.glutenFree)
                        Text("Jain").tag(UserAttributes.FoodPreference.jain)
                    }
                    
                    // Cleanliness rating out of 5
                    Stepper(value: $viewModel.cleanliness, in: 0...5) {
                        HStack {
                            Text("Cleanliness: ")
                            Text("\(viewModel.cleanliness)").foregroundColor(.accentColor)
                        }
                    }
                    
                    // Sleep schedule
                    Picker(selection: $viewModel.sleepSchedule, label: Text("Sleep Schedule")) {
                        Text("Early Bird").tag(UserAttributes.SleepSchedule.earlyBird)
                        Text("Night Owl").tag(UserAttributes.SleepSchedule.nightOwl)
                        Text("Somewhere in Between").tag(UserAttributes.SleepSchedule.somewhereInBetween)
                    }
                    
                    // Is Smoker
                    Toggle(isOn: $viewModel.smoking) {
                        Text("Smoking")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: Color.accentColor))
                    
                    // Is party person
                    Toggle(isOn: $viewModel.partying) {
                        Text("Partying")
                    }.toggleStyle(SwitchToggleStyle(tint: Color.accentColor))
                    
                    // Is pet friendly
                    Toggle(isOn: $viewModel.petFriendly) {
                        Text("Pet Friendly")
                    }.toggleStyle(SwitchToggleStyle(tint: Color.accentColor))
                    
                }
                VStack {
                    Rectangle().frame(height: 40).opacity(0)
                        
                }.listRowBackground(Color("BackgroundColor"))
            }
            // Show image picker
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $viewModel.profileImage)
                
            }
            .onAppear {
                viewModel.getUserDetail(userId: appState.userId!) {result in}
            }
            .background(Color("BackgroundColor"))
            .scrollContentBackground(.hidden)
            
            // Zstack layer two
            // Save and Cancel Buttons
            VStack {
                Spacer()
                // If onboarder show both save and cancel buttons.
                if appState.isOnboarded {
                    HStack(alignment: .bottom) {
                        
                        // cancel button: resets all changes made
                        Button(action: {
                            viewModel.getUserDetail(userId: appState.userId!) {result in}
                            
                        }) {
                            Text("Cancel")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        
                        // save button: Save changes made by user to database.
                        Button(action: {
                            if (viewModel.validate()) {
                                viewModel.postUserDetail(userId: appState.userId!, email: appState.userEmail!)
                                appState.userName = viewModel.name
                                self.alertText = "Profile Updated"
                                self.showingAlert = true
                            }
                            else {
                                self.alertText = "Please add all mandaotory fields"
                                self.showingAlert = true
                            }
                        }) {
                            Text("Save")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .background(Color("SecondaryAccentColor"))
                    .frame(width: 300, height: 40)
                    .cornerRadius(10)
                }
                
                // If not onboard: Only show save button.
                else {
                    HStack(alignment: .bottom) {
                        
                        // save button
                        Button(action: {
                            if (viewModel.validate()) {
                                viewModel.postUserDetail(userId: appState.userId!, email: appState.userEmail!)
                                appState.userName = viewModel.name
                                appState.isOnboarded = true
                                self.alertText = "Profile Updated"
                                self.showingAlert = true
                            }
                            else {
                                self.alertText = "Please add all mandaotory fields"
                                self.showingAlert = true
                            }
                            
                        }) {
                            Text("Save")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .background(Color("SecondaryAccentColor"))
                    .frame(width: 80, height: 40)
                    .cornerRadius(15)
                }
            }
            .padding()
            .padding(.vertical, 70)
            .ignoresSafeArea()
            .opacity(0.95)
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(alertText), dismissButton: .default(Text("OK")))
        }
        
    }
}



struct AccountView_Previews: PreviewProvider {
    static func getAppState() -> AppState {
        
        let appState = AppState(isOnboarded: true, userId: "123", userName: "John Doe", profileImage: UIImage(named: "defaultProfile"), userEmail: "hey@gmail.com")
        return appState
        
    }
    static var previews: some View {
        AccountView().environmentObject(getAppState())
    }
}
