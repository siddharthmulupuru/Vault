//
//  ChangePasswordView.swift
//  Vault
//
//  Created by Siddharth Mulupuru on 7/10/26.
//

import SwiftUI

struct ChangePasswordView: View {
    @Environment(LoginViewModel.self) var loginVM
    @Environment(VaultEntryViewModel.self) var vaultEntryVM
    @Environment(\.dismiss) var dismiss
    
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showingError = false
    @FocusState private var textFieldFocused: Bool
    
    var body: some View {
        ZStack {
            Color(red: 0.47, green: 0.07, blue: 1.02)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Change Password")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Current Password")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                    SecureField("Current Password", text: $currentPassword)
                        .focused($textFieldFocused)
                        .padding()
                        .background(.white.opacity(0.1))
                        .cornerRadius(10)
                        .foregroundStyle(.white)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("New Password")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                    SecureField("New Password", text: $newPassword)
                        .focused($textFieldFocused)
                        .padding()
                        .background(.white.opacity(0.1))
                        .cornerRadius(10)
                        .foregroundStyle(.white)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Confirm New Password")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                    SecureField("Confirm New Password", text: $confirmPassword)
                        .focused($textFieldFocused)
                        .padding()
                        .background(.white.opacity(0.1))
                        .cornerRadius(10)
                        .foregroundStyle(.white)
                }
                
                if newPassword != confirmPassword && !confirmPassword.isEmpty {
                    Text("Passwords do not match")
                        .foregroundStyle(.red)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Button {
                    guard newPassword == confirmPassword else { return }
                    Task {
                        await loginVM.changePassword(
                            currentPassword: currentPassword,
                            newPassword: newPassword,
                            currentEntries: vaultEntryVM.vaultEntries
                        )
                        if loginVM.errorMessage == nil {
                            dismiss()
                        }
                    }
                } label: {
                    Text("Change Password")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(newPassword == confirmPassword && !newPassword.isEmpty ? Color.purple : Color.gray)
                        .cornerRadius(12)
                }
                .disabled(newPassword != confirmPassword || newPassword.isEmpty || currentPassword.isEmpty)
                .padding(.top)
                
                Spacer()
            }
            .padding()
        }
        .onTapGesture {
            textFieldFocused = false
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) {
                loginVM.errorMessage = nil
            }
        } message: {
            Text(loginVM.errorMessage ?? "")
        }
        .onChange(of: loginVM.errorMessage) { _, newValue in
            if newValue != nil {
                showingError = true
            }
        }
    }
}

#Preview {
    ChangePasswordView()
        .environment(LoginViewModel())
        .environment(VaultEntryViewModel())
}
