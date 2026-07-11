//
//  HomeView.swift
//  Vault
//
//  Created by Siddharth Mulupuru on 7/4/26.
//

import SwiftUI

struct HomeView: View {
    @State private var query = ""
    @State private var showingError = false
    @FocusState private var queryBoxFocused: Bool
    @Environment(LoginViewModel.self) var loginVM
    @Environment(VaultEntryViewModel.self) var vaultEntryVM
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.27, green: 0.04, blue: 0.59)
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        // Invisible placeholder same width as button
                        HStack {
                            Text("Logout")
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                        }
                        .padding(.horizontal)
                        .frame(height: 32)
                        .opacity(0)
                        
                        Spacer()
                        
                        Text("Vault")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        Button {
                            vaultEntryVM.logout()
                            loginVM.logout()
                        } label: {
                            HStack {
                                Text("Logout")
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                            }
                            .padding(.horizontal)
                            .frame(height: 32)
                            .background(.clear)
                            .foregroundStyle(Color(red: 0.52, green: 0.09, blue: 1.12))
                            .cornerRadius(6)
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        TextField("Search passwords...", text: $query)
                            .textFieldStyle(.roundedBorder)
                            .focused($queryBoxFocused)
                        
                        Button {
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
                    
                    HStack {
                        NavigationLink {
                            ChangePasswordView()
                        } label: {
                            HStack {
                                Text("Change Password")
                                Image(systemName: "key.horizontal")
                            }
                            .padding(.horizontal)
                            .frame(height: 32)
                            .background(.indigo)
                            .foregroundStyle(.white)
                            .cornerRadius(6)
                        }
                        
                        Spacer()
                        
                        NavigationLink {
                            AddOrEditEntryView(vaultEntry: VaultEntry(id: "newEntry"), title: "Add Entry")
                        } label: {
                            HStack {
                                Image(systemName: "plus")
                                
                                Text("Add Entry")
                            }
                            .padding(.horizontal)
                            .frame(height: 32)
                            .background(.purple)
                            .foregroundColor(.white)
                            .cornerRadius(6)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    ScrollView {
                        ForEach(vaultEntryVM.vaultEntries, id: \.id) { vaultEntry in
                            if (query == "" || vaultEntry.name?.lowercased().contains(query.lowercased()) ?? false || vaultEntry.username?.lowercased().contains(query.lowercased()) ?? false) {
                                NavigationLink {
                                    AddOrEditEntryView(vaultEntry: vaultEntry, title: "Edit Entry")
                                } label: {
                                    VaultEntryView(vaultEntry: vaultEntry)
                                        .padding(.bottom, 10)
                                }
                            }
                        }
                        .padding()
                    }
                    .scrollIndicators(.hidden)
                    .refreshable {
                        await vaultEntryVM.loadEntries(token: loginVM.token!, key: loginVM.encryptionKey!)
                    }
                }
                .padding(.top)
            }
            .onTapGesture {
                queryBoxFocused = false
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
