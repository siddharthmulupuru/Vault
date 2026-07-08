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
        return ""
    }
    
    func decryptFromString(key: String, ciphertext: String) throws -> String {
        return ""
    }
}
