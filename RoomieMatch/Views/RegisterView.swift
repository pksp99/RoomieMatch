//
//  RegisterView.swift
//  RoomieMatch
//
//  Created by Preet Karia on 5/2/23.
//

import SwiftUI

import Firebase

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var error = ""
    
    @Binding var isRegisteredNow: Bool
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16.0) {
                
                // Add user image
                Image(systemName: "person.crop.circle.badge.plus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .padding(.bottom, 40)
                
                // Email
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 16)
                    .frame(height: 50)
                    .background(Color(.white))
                    .cornerRadius(10)
                
                // Password
                SecureField("Password", text: $password)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 16)
                    .frame(height: 50)
                    .background(Color(.white))
                    .cornerRadius(10)
                
                // Confirm Password
                SecureField("Confirm Password", text: $confirmPassword)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 16)
                    .frame(height: 50)
                    .background(Color(.white))
                    .cornerRadius(10)
                    .padding(.bottom)
                
                // Register Button
                Button(action: {
                    register()
                }) {
                    Text("Register")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                }
                .padding(.vertical)
                
                if !error.isEmpty {
                    Text(error)
                        .foregroundColor(.red)
                        .padding(.top)
                }
                
                
            }
            .navigationBarTitle("Register")
            .padding()
            
        }
        .background(Color("BackgroundColor"))
    }
    
    // Register Button action
    func register() {
        // validate password before registering.
        if password != confirmPassword {
            self.error = "Both password should match"
            return
        }
        
        // Firebase call to create User
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.error = error.localizedDescription
            } else {
                let userId = Auth.auth().currentUser?.uid
                appState.userId = userId
                NetworkRequester.shared.userId = userId!
                appState.userEmail = email
                self.isRegisteredNow = true
                print("New account registered")
            }
        }
    }
}



struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(isRegisteredNow: .constant(false))
    }
}

