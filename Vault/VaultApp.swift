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
            if (loginVM.isLoggedIn) {
                HomeView()
                    .environment(loginVM)
                    .environment(vaultEntryVM)
            } else {
                LoginView()
                    .environment(loginVM)
            }
        }
    }
}
