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
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(Color(red: 0.27, green: 0.04, blue: 0.59))
            
            VStack {
                Spacer()
                
                Text("Vault")
                    .font(.largeTitle)
                
                TextField("Username", text: $username)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 100)
                
                SecureField("Password", text: $password)
                    .textContentType(.password)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 100)
                
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    LoginView()
}
