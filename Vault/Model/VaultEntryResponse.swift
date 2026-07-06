//
//  VaultEntryResponse.swift
//  Vault
//
//  Created by Siddharth Mulupuru on 7/5/26.
//

import Foundation

struct VaultEntryResponse: Codable {
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
