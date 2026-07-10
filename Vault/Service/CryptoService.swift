//
//  CryptoService.swift
//  Vault
//
//  Created by Siddharth Mulupuru on 7/7/26.
//

import Foundation
import CryptoKit
import CommonCrypto

struct CryptoService {
    func deriveKey(password: String, salt: String) throws -> SymmetricKey {
        let passwordData = Data(password.utf8)
        
        guard let saltData = Data(base64Encoded: salt) else {
            throw CryptoKitError.invalidParameter
        }
        
        var derivedKey = [UInt8](repeating: 0, count: 32)
        
        let result = CCKeyDerivationPBKDF(CCPBKDFAlgorithm(kCCPBKDF2), password, passwordData.count, [UInt8](saltData), saltData.count, CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256), 1_000_000, &derivedKey, 32)
        
        guard (result == kCCSuccess) else {
            throw CryptoKitError.authenticationFailure
        }
        
        return SymmetricKey(data: Data(derivedKey))
    }
    
    func encryptToString(key: SymmetricKey, plaintext: String) throws -> String {
        let plaintextData = Data(plaintext.utf8)
        let iv = AES.GCM.Nonce()
        
        let sealedBox = try AES.GCM.seal(plaintextData, using: key, nonce: iv)
        
        var combined = Data()
        combined.append(contentsOf: iv)
        combined.append(sealedBox.ciphertext)
        combined.append(sealedBox.tag)
        
        return combined.base64EncodedString()
    }
    
    func decryptFromString(key: SymmetricKey, ciphertext: String) throws -> String {
        guard let combined = Data(base64Encoded: ciphertext) else {
            throw CryptoKitError.invalidParameter
        }
        
        let iv = combined.prefix(12)
        let ciphertextAndTag = combined.dropFirst(12)
        
        let nonce = try AES.GCM.Nonce(data: iv)
        let sealedBox = try AES.GCM.SealedBox(nonce: nonce, ciphertext: ciphertextAndTag.dropLast(16), tag: ciphertextAndTag.suffix(16))
        let decryptedData = try AES.GCM.open(sealedBox, using: key)
        
        guard let plaintext = String(data: decryptedData, encoding: .utf8) else {
            throw CryptoKitError.invalidParameter
        }
        
        return plaintext
    }
}
