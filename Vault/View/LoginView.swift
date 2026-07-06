//
//  LoginView.swift
//  Vault
//
//  Created by Siddharth Mulupuru on 7/5/26.
//

import SwiftUI

struct LoginView: View {
    @State var username: String = ""
    @State var password: String = ""
    @FocusState var textFieldFocused: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(Color(red: 0.27, green: 0.04, blue: 0.59))
            
            VStack {
                Spacer()
                
                Text("Vault")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                
                TextField("Username", text: $username)
                    .focused($textFieldFocused)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 100)
                
                SecureField("Password", text: $password)
                    .focused($textFieldFocused)
                    .textContentType(.password)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 100)
                
                Button {
                    textFieldFocused = false
                } label: {
                    Text("Sign in")
                        .padding(.horizontal)
                        .frame(height: 32)
                        .frame(width: 200)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }
                
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    LoginView()
}
