//
//  HomeView.swift
//  Vault
//
//  Created by Siddharth Mulupuru on 7/4/26.
//

import SwiftUI

struct HomeView: View {
    @State var query = ""
    @State var showingError = false
    @FocusState var queryBoxFocused: Bool
    @Environment(LoginViewModel.self) var loginVM
    @Environment(VaultEntryViewModel.self) var vaultEntryVM
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.27, green: 0.04, blue: 0.59)
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        TextField("Search passwords...", text: $query)
                            .textFieldStyle(.roundedBorder)
                            .focused($queryBoxFocused)
                        
                        Button {
                            // Perform a search
                            // Also do search while typing too
                            queryBoxFocused = false
                        } label: {
                            Text("Go")
                                .padding(.horizontal)
                                .frame(height: 32)
                                .background(.blue)
                                .foregroundColor(.white)
                                .cornerRadius(6)
                        }
                    }
                    .padding(.horizontal)
                    
                    ScrollView {
                        ForEach(vaultEntryVM.vaultEntries, id: \.id) { vaultEntry in
                            NavigationLink {
                                EditEntryView(vaultEntry: vaultEntry)
                            } label: {
                                VaultEntryView(vaultEntry: vaultEntry)
                                    .padding(.bottom, 10)
                            }
                        }
                        .padding()
                    }
                }
                .padding(.top)
            }
            .onAppear {
                Task {
                    await vaultEntryVM.loadEntries(token: loginVM.token!, key: loginVM.encryptionKey!)
                }
            }
        }
        .buttonStyle(.plain)
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
    HomeView()
}
