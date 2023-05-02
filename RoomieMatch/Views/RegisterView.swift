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
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
            ScrollView {
                VStack {
                    
                    VStack(spacing: 16) {
                        
                        Image(systemName: "person.crop.circle.badge.plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .padding(.bottom, 40)
                        
                        TextField("Email", text: $email)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding(.horizontal, 16)
                            .frame(height: 50)
                            .background(Color(.white))
                            .cornerRadius(10)
                        
                        SecureField("Password", text: $password)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding(.horizontal, 16)
                            .frame(height: 50)
                            .background(Color(.white))
                            .cornerRadius(10)
                        SecureField("Confirm Password", text: $confirmPassword)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding(.horizontal, 16)
                            .frame(height: 50)
                            .background(Color(.white))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
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
                    .padding(.horizontal)
                    .padding(.vertical)
                    
                    if !error.isEmpty {
                        Text(error)
                            .foregroundColor(.red)
                            .padding(.top)
                    }
                    
                    
                }
                .navigationBarTitle("Register")
               
                
            }
            .background(Color("BackgroundColor"))
        }
    func register() {
        if password != confirmPassword {
            self.error = "Both password should match"
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.error = error.localizedDescription
            } else {
                appState.isOnboarded = true
                // TODO add some logic here to get user data after registering
            }
        }
    }
}



struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

