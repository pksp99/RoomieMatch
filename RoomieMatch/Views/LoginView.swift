//
//  LoginView.swift
//  RoomieMatch
//
//  Created by Preet Karia on 5/2/23.
//

import SwiftUI

import Firebase

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var error = ""
    @EnvironmentObject var appState: AppState
    var accountsViewModel = AccountsViewModel()
    @Binding var isRegisteredNow: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    // App Logo
                    Image("ig-logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .padding(.bottom, 40)
                    
                    //Email and Password
                    VStack(spacing: 16) {
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
                    }
                    .padding(.horizontal)
                    
                    
                    // Login Button
                    Button(action: {
                        login()
                    }) {
                        Text("Log In")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.accentColor)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.vertical)
                    
                    
                    // Register button for new user.
                    NavigationLink(destination: RegisterView(isRegisteredNow: $isRegisteredNow).environmentObject(appState))
                    {
                        HStack {
                            Text("Don't have an account?")
                                .foregroundColor(.gray)
                            Text("Register")
                                .foregroundColor(.accentColor)
                                .fontWeight(.semibold)
                        }
                    }
                    
                    if !error.isEmpty {
                        Text(error)
                            .foregroundColor(.red)
                            .padding(.top)
                    }
                    
                }
                .navigationBarTitle("Log In")
                
            }
            .background(Color("BackgroundColor"))
        }
    }
    
    // login button action.
    func login() {
        
        // Firebase call to sign in
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.error = error.localizedDescription
            } else {
                
                // setting appState and userId in networkRequestor after logged in.
                let userId = Auth.auth().currentUser?.uid
                appState.isOnboarded = true
                appState.userId = userId
                NetworkRequester.shared.userId = userId!
                accountsViewModel.getUserDetail(userId: userId!) { result in
                    appState.userEmail = result.email
                    appState.userName = result.userAttributes.name
                }
                
            }
        }
    }
}



struct LoginView_Previews: PreviewProvider {
    
    // Just for Preview
    static func getAppState() -> AppState {
        
        let appState = AppState(isOnboarded: true, userId: "123", userName: "John Doe", profileImage: UIImage(named: "defaultProfile"), userEmail: "hey@gmail.com")
        return appState

    }
    static var previews: some View {
        LoginView(isRegisteredNow: .constant(false)).environmentObject(getAppState())
    }
}
