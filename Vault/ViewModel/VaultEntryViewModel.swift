//
//  VaultEntryViewModel.swift
//  Vault
//
//  Created by Siddharth Mulupuru on 7/7/26.
//

import Foundation
import CryptoKit

@Observable
class VaultEntryViewModel {
    var vaultEntries: [VaultEntry] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    let dataService = DataService()
    
    func loadEntries(token: String, key: SymmetricKey) async {
        isLoading = true
        errorMessage = nil
        do {
            vaultEntries = try await dataService.getVaultEntries(token: token, key: key)
        } catch {
            errorMessage = "Failed to load entries"
        }
        isLoading = false
    }
    
    func createEntry(token: String, key: SymmetricKey, entry: VaultEntry) async {
        do {
            try await dataService.createVaultEntry(token: token, key: key, entry: entry)
            await loadEntries(token: token, key: key)
        } catch {
            errorMessage = "Failed to create entry"
        }
    }
    
    func updateEntry(token: String, key: SymmetricKey, entry: VaultEntry) async {
        do {
            try await dataService.updateVaultEntry(token: token, key: key, entry: entry)
            await loadEntries(token: token, key: key)
        } catch {
            errorMessage = "Failed to update entry"
        }
    }
    
    func deleteEntry(token: String, id: String, key: SymmetricKey) async {
        do {
            try await dataService.deleteVaultEntry(token: token, id: id)
            await loadEntries(token: token, key: key)
        } catch {
            errorMessage = "Failed to delete entry"
        }
    }
}
