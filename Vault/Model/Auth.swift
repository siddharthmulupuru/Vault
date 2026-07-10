//
//  Auth.swift
//  Vault
//
//  Created by Siddharth Mulupuru on 7/9/26.
//

import Foundation

struct LoginRequest: Encodable {
    let username: String
    let password: String
}

struct LoginResponse: Decodable {
    let token: String
    let salt: String
}

struct ChangePasswordRequest: Encodable {
    let currentPassword: String
    let newPassword: String
    let newSalt: String
    let entries: [VaultEntryRequest]
}
