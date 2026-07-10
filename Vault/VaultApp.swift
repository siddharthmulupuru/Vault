//
//  VaultApp.swift
//  Vault
//
//  Created by Siddharth Mulupuru on 7/4/26.
//

import SwiftUI

@main
struct VaultApp: App {
    @State var loginVM = LoginViewModel()
    @State var vaultEntryVM = VaultEntryViewModel()
    
    var body: some Scene {
        WindowGroup {
//            LoginView()
//                .environment(loginVM)
            
            HomeView(vaultEntries: [VaultEntry(
                id: "abc123",
                name: "Gmail",
                website: "https://gmail.com",
                username: "siddh",
                email: "siddh@gmail.com",
                password: "mypasswasdfsad",
                description: "Personal email account",
                createdAt: "2026-01-01",
                updatedAt: "2026-01-01"
            )])
                .environment(vaultEntryVM)
        }
    }
}
