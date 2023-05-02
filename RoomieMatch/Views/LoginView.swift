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
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Image("ig-logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .padding(.bottom, 40)
                    
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
                    
                    
                    
                    NavigationLink(destination: RegisterView().environmentObject(appState))
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
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.error = error.localizedDescription
            } else {
                let userId = Auth.auth().currentUser?.uid
                appState.isOnboarded = true
                appState.userId = userId
                
            }
        }
    }
}



struct LoginView_Previews: PreviewProvider {
    
    // Just for Preview
    static func getAppState() -> AppState {
        
        let appState = AppState(isOnboarded: true, userId: "123", userName: "John Doe", profileImage: UIImage(named: "defaultProfile"))
        return appState

    }
    static var previews: some View {
        LoginView().environmentObject(getAppState())
    }
}
