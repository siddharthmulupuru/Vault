//
//  DataService.swift
//  Vault
//
//  Created by Siddharth Mulupuru on 7/5/26.
//

import Foundation
import CryptoKit

struct DataService {
    private let baseURL: String
    let cryptoService = CryptoService()
    
    let sharedSession: URLSession = {
        let delegate = SelfSignedCertDelegate()
        return URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
    }()
    
    init(baseURL: String = "https://raspberry-pi-password-manager-server.cinnamon-hadar.ts.net") {
        self.baseURL = baseURL
    }
    
    func login(username: String, password: String) async throws -> (token: String, salt: String) {
        // 1. Create URL
        guard let url = URL(string: "\(baseURL)/api/auth/login") else {
            throw URLError(.badURL)
        }
        
        // 2. Create request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginRequest = LoginRequest(username: username, password: password)
        request.httpBody = try JSONEncoder().encode(loginRequest)
        
        // 3. Send request
        let (data, response) = try await sharedSession.data(for: request)
        
        // 4. Parse response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let result = try JSONDecoder().decode(LoginResponse.self, from: data)
        return (token: result.token, salt: result.salt)
    }
    
    func getVaultEntries(token: String, key: SymmetricKey) async throws -> [VaultEntry] {
        // 1. Create URL
        guard let url = URL(string: "\(baseURL)/api/vault") else {
            throw URLError(.badURL)
        }
        
        // 2. Create request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // 3. Send request
        let (data, response) = try await sharedSession.data(for: request)
        
        // 4. Parse response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let entries = try JSONDecoder().decode([VaultEntryResponse].self, from: data)
        
        // 5. Decrypt entries
        return try entries.map { entry in
            VaultEntry(
                id: entry.id,
                name: entry.encryptedName != nil ? try cryptoService.decryptFromString(key: key, ciphertext: entry.encryptedName!) : nil,
                website: entry.encryptedWebsite != nil ? try cryptoService.decryptFromString(key: key, ciphertext: entry.encryptedWebsite!) : nil,
                username: entry.encryptedWebsiteUsername != nil ? try cryptoService.decryptFromString(key: key, ciphertext: entry.encryptedWebsiteUsername!) : nil,
                email: entry.encryptedWebsiteEmail != nil ? try cryptoService.decryptFromString(key: key, ciphertext: entry.encryptedWebsiteEmail!) : nil,
                password: entry.encryptedWebsitePassword != nil ? try cryptoService.decryptFromString(key: key, ciphertext: entry.encryptedWebsitePassword!) : nil,
                description: entry.encryptedDescription != nil ? try cryptoService.decryptFromString(key: key, ciphertext: entry.encryptedDescription!) : nil,
                createdAt: entry.createdAt,
                updatedAt: entry.updatedAt
            )
        }
    }
    
    func createVaultEntry(token: String, key: SymmetricKey, entry: VaultEntry) async throws -> VaultEntry {
        // 1. Create URL
        guard let url = URL(string: "\(baseURL)/api/vault") else {
            throw URLError(.badURL)
        }
        
        // 2. Encrypt all fields
        let requestBody = VaultEntryRequest(
            encryptedName: entry.name != nil ? try cryptoService.encryptToString(key: key, plaintext: entry.name!) : nil,
            encryptedWebsite: entry.website != nil ? try cryptoService.encryptToString(key: key, plaintext: entry.website!) : nil,
            encryptedWebsiteUsername: entry.username != nil ? try cryptoService.encryptToString(key: key, plaintext: entry.username!) : nil,
            encryptedWebsiteEmail: entry.email != nil ? try cryptoService.encryptToString(key: key, plaintext: entry.email!) : nil,
            encryptedWebsitePassword: entry.password != nil ? try cryptoService.encryptToString(key: key, plaintext: entry.password!) : nil,
            encryptedDescription: entry.description != nil ? try cryptoService.encryptToString(key: key, plaintext: entry.description!) : nil
        )
        
        // 3. Create request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        // 4. Send request
        let (data, response) = try await sharedSession.data(for: request)
        
        // 5. Parse response
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 201 else {
            throw URLError(.badServerResponse)
        }
        
        // 6. Decode and decrypt response
        let created = try JSONDecoder().decode(VaultEntryResponse.self, from: data)
        return VaultEntry(
            id: created.id,
            name: entry.name,
            website: entry.website,
            username: entry.username,
            email: entry.email,
            password: entry.password,
            description: entry.description,
            createdAt: created.createdAt,
            updatedAt: created.updatedAt
        )
    }
    
    func updateVaultEntry(token: String, key: SymmetricKey, entry: VaultEntry) async throws -> VaultEntry {
        // 1. Create URL
        guard let url = URL(string: "\(baseURL)/api/vault/\(entry.id)") else {
            throw URLError(.badURL)
        }
        
        // 2. Encrypt all fields
        let requestBody = VaultEntryRequest(
            encryptedName: entry.name != nil ? try cryptoService.encryptToString(key: key, plaintext: entry.name!) : nil,
            encryptedWebsite: entry.website != nil ? try cryptoService.encryptToString(key: key, plaintext: entry.website!) : nil,
            encryptedWebsiteUsername: entry.username != nil ? try cryptoService.encryptToString(key: key, plaintext: entry.username!) : nil,
            encryptedWebsiteEmail: entry.email != nil ? try cryptoService.encryptToString(key: key, plaintext: entry.email!) : nil,
            encryptedWebsitePassword: entry.password != nil ? try cryptoService.encryptToString(key: key, plaintext: entry.password!) : nil,
            encryptedDescription: entry.description != nil ? try cryptoService.encryptToString(key: key, plaintext: entry.description!) : nil
        )
        
        // 3. Create request
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        // 4. Send request
        let (data, response) = try await sharedSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // 5. Decode response
        let updated = try JSONDecoder().decode(VaultEntryResponse.self, from: data)
        return VaultEntry(
            id: updated.id,
            name: entry.name,
            website: entry.website,
            username: entry.username,
            email: entry.email,
            password: entry.password,
            description: entry.description,
            createdAt: updated.createdAt,
            updatedAt: updated.updatedAt
        )
    }
    
    func deleteVaultEntry(token: String, id: String) async throws {
        // 1. Create URL
        guard let url = URL(string: "\(baseURL)/api/vault/\(id)") else {
            throw URLError(.badURL)
        }
        
        // 2. Create request
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // 3. Send request
        let (_, response) = try await sharedSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 204 else {
            throw URLError(.badServerResponse)
        }
    }
    
    func changePassword(token: String, oldKey: SymmetricKey, currentPassword: String, newPassword: String, currentEntries: [VaultEntry]) async throws -> (token: String, salt: String) {
        guard let url = URL(string: "\(baseURL)/api/auth/password") else {
            throw URLError(.badURL)
        }
        
        // 1. Generate new salt and derive new key
        let newSalt = cryptoService.generateSalt()
        let newKey = try cryptoService.deriveKey(password: newPassword, salt: newSalt)
        
        // 2. Re-encrypt all entries with new key
        let reEncryptedEntries = try currentEntries.map { entry in
            VaultEntryRequest(
                encryptedName: entry.name != nil ? try cryptoService.encryptToString(key: newKey, plaintext: entry.name!) : nil,
                encryptedWebsite: entry.website != nil ? try cryptoService.encryptToString(key: newKey, plaintext: entry.website!) : nil,
                encryptedWebsiteUsername: entry.username != nil ? try cryptoService.encryptToString(key: newKey, plaintext: entry.username!) : nil,
                encryptedWebsiteEmail: entry.email != nil ? try cryptoService.encryptToString(key: newKey, plaintext: entry.email!) : nil,
                encryptedWebsitePassword: entry.password != nil ? try cryptoService.encryptToString(key: newKey, plaintext: entry.password!) : nil,
                encryptedDescription: entry.description != nil ? try cryptoService.encryptToString(key: newKey, plaintext: entry.description!) : nil
            )
        }
        
        // 3. Build request
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let body = ChangePasswordRequest(
            currentPassword: currentPassword,
            newPassword: newPassword,
            newSalt: newSalt,
            entries: reEncryptedEntries
        )
        request.httpBody = try JSONEncoder().encode(body)
        
        // 4. Send request
        let (data, response) = try await sharedSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let result = try JSONDecoder().decode(LoginResponse.self, from: data)
        return (token: result.token, salt: result.salt)
    }
}
