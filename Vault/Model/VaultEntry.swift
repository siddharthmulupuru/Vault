//
//  VaultEntry.swift
//  Vault
//
//  Created by Siddharth Mulupuru on 7/5/26.
//

import Foundation

struct VaultEntry: Identifiable {
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
