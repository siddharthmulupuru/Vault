//
//  HomeView.swift
//  Vault
//
//  Created by Siddharth Mulupuru on 7/4/26.
//

import SwiftUI

struct HomeView: View {
    @State var vaultEntries: [VaultEntry]
    @State var query = ""
    @FocusState var queryBoxFocused: Bool
    
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
                        ForEach(vaultEntries, id: \.id) { vaultEntry in
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
                    // Populate the data
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HomeView(vaultEntries: [
        VaultEntry(
            id: "abc123",
            name: "Gmail",
            website: "https://gmail.com",
            username: "siddhsiddhsiddhsiddhsiddhsiddhsiddhsiddh",
            email: "siddharthmulupuru100siddharthmulupuru18@gmail.com",
            password: "mypassword123",
            description: "Personal email account",
            createdAt: "2026-01-01",
            updatedAt: "2026-01-01"
        ),
        VaultEntry(
            id: "def456",
            name: "GitHub",
            website: "https://github.com",
            username: "siddharthmulupuru",
            email: "siddh@gmail.com",
            password: "github456",
            description: "Code repository",
            createdAt: "2026-01-01",
            updatedAt: "2026-01-01"
        ),
        VaultEntry(
            id: "ghi789",
            name: "Amazon",
            website: "https://amazon.com",
            username: "siddh",
            email: "siddh@gmail.com",
            password: "amazon789",
            description: nil,
            createdAt: "2026-01-01",
            updatedAt: "2026-01-01"
        )
    ])
}
