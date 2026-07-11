//
//  VaultEntry.swift
//  Vault
//
//  Created by Siddharth Mulupuru on 7/5/26.
//

import Foundation

struct VaultEntry: Identifiable, Hashable {
    var id: String
    var name: String?
    var website: String?
    var username: String?
    var email: String?
    var password: String?
    var description: String?
    var createdAt: String?
    var updatedAt: String?
}

struct VaultEntryRequest: Encodable {
    let encryptedName: String?
    let encryptedWebsite: String?
    let encryptedWebsiteUsername: String?
    let encryptedWebsiteEmail: String?
    let encryptedWebsitePassword: String?
    let encryptedDescription: String?
}

struct VaultEntryResponse: Decodable {
    var id: String
    var encryptedName: String?
    var encryptedWebsite: String?
    var encryptedWebsiteUsername: String?
    var encryptedWebsiteEmail: String?
    var encryptedWebsitePassword: String?
    var encryptedDescription: String?
    var createdAt: String?
    var updatedAt: String?
}
