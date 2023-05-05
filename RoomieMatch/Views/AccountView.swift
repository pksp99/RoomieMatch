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
            Form {
                Section(header: Text("Personal Information")) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("User Name")
                            Text("*").foregroundColor(.accentColor)
                        }
                        TextField("Name", text: $viewModel.name).foregroundColor(Color("DarkGray"))
                            .disableAutocorrection(true)
                    }
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Intro")
                            Text("*").foregroundColor(.accentColor)
                        }
                        TextField("Breif one line intro", text: $viewModel.intro)
                            .foregroundColor(Color("DarkGray"))
                    }
                    Picker(selection: $viewModel.gender, label: Text("Gender")) {
                        ForEach(UserAttributes.Gender.allCases, id: \.self) { preference in
                            Text(preference.rawValue.capitalized).tag(preference)
                        }
                    }
                    
                    Picker(selection: $viewModel.major, label: Text("Major")) {
                        ForEach(UserAttributes.Major.allCases, id: \.self) { preference in
                            Text(preference.rawValue.capitalized).tag(preference)
                        }
                    }
                    DatePicker(
                        selection: $viewModel.dateAvailable,
                        in: Date()...,
                        displayedComponents: [.date]
                    ) {
                        Text("Date Available")
                    }
                }
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
                Section(header: HStack {
                    Text("Budget")
                    Text("*").foregroundColor(.accentColor)
                }) {
                    HStack {
                        Text("$").foregroundColor(.accentColor)
                        TextField("Monthly Budget", value: $viewModel.monthlyBudet, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .foregroundColor(Color("DarkGray"))
                    }
                }
                
                Section(header: Text("Bio")) {TextEditor(text: $viewModel.bio)
                        .frame(height: 100)
                        .cornerRadius(8)
                        .foregroundColor(Color("DarkGray"))
                }
                
                Section(header: Text("Preferences")) {
                    Picker(selection: $viewModel.foodPreference, label: Text("Food Preference")) {
                        Text("No Preference").tag(UserAttributes.FoodPreference.noPreference)
                        Text("Vegetarian").tag(UserAttributes.FoodPreference.vegetarian)
                        Text("Vegan").tag(UserAttributes.FoodPreference.vegan)
                        Text("Gluten Free").tag(UserAttributes.FoodPreference.glutenFree)
                        Text("Jain").tag(UserAttributes.FoodPreference.jain)
                    }
                    
                    Stepper(value: $viewModel.cleanliness, in: 0...5) {
                        HStack {
                            Text("Cleanliness: ")
                            Text("\(viewModel.cleanliness)").foregroundColor(.accentColor)
                        }
                    }
                    
                    Picker(selection: $viewModel.sleepSchedule, label: Text("Sleep Schedule")) {
                        Text("Early Bird").tag(UserAttributes.SleepSchedule.earlyBird)
                        Text("Night Owl").tag(UserAttributes.SleepSchedule.nightOwl)
                        Text("Somewhere in Between").tag(UserAttributes.SleepSchedule.somewhereInBetween)
                    }
                    
                    Toggle(isOn: $viewModel.somking) {
                        Text("Smoking")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: Color.accentColor))
                    
                    Toggle(isOn: $viewModel.partying) {
                        Text("Partying")
                    }.toggleStyle(SwitchToggleStyle(tint: Color.accentColor))
                    
                    Toggle(isOn: $viewModel.pet_friedly) {
                        Text("Pet Friendly")
                    }.toggleStyle(SwitchToggleStyle(tint: Color.accentColor))
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $viewModel.profileImage)
                
            }
            .onAppear {
                viewModel.getUserDetail(userId: appState.userId!)
            }
            .background(Color("BackgroundColor"))
            .scrollContentBackground(.hidden)
            
            
            VStack {
                Spacer()
                if appState.isOnboarded {
                    HStack(alignment: .bottom) {
                        Button(action: {
                            viewModel.getUserDetail(userId: appState.userId!)
                            
                        }) {
                            Text("Cancel")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Button(action: {
                            if (viewModel.validate()) {
                                viewModel.postUserDetail(userId: appState.userId!, email: appState.userEmail!)
                                
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
                else {
                    HStack(alignment: .bottom) {
                        
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
