//
//  LoginViewModel.swift
//  Vault
//
//  Created by Siddharth Mulupuru on 7/5/26.
//

import Foundation
import CryptoKit

@Observable
class LoginViewModel {
    var isLoggedIn: Bool = false
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    var token: String? = nil
    var encryptionKey: SymmetricKey? = nil
    
    let dataService = DataService()
    
    func login(username: String, password: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let (token, salt) = try await dataService.login(username: username, password: password)
            let key = try dataService.cryptoService.deriveKey(password: password, salt: salt)
            self.token = token
            self.encryptionKey = key
            self.isLoggedIn = true
        } catch {
            errorMessage = "Invalid username or password"
        }
        isLoading = false
    }
    
    func logout() {
        token = nil
        encryptionKey = nil
        errorMessage = nil
        isLoading = false
        isLoggedIn = false
    }
    
    func changePassword(currentPassword: String, newPassword: String, currentEntries: [VaultEntry]) async {
        isLoading = true
        errorMessage = nil
        do {
            let (newToken, newSalt) = try await dataService.changePassword(
                token: token!,
                oldKey: encryptionKey!,
                currentPassword: currentPassword,
                newPassword: newPassword,
                currentEntries: currentEntries
            )
            self.token = newToken
            self.encryptionKey = try dataService.cryptoService.deriveKey(password: newPassword, salt: newSalt)
        } catch {
            errorMessage = "Failed to change password"
        }
        isLoading = false
    }
}
