//
//  Password.swift
//  FileManagerStoryboard
//
//  Created by Мария Межова on 11.09.2022.
//

import Foundation
import KeychainAccess

struct Password {
    
    private let key = "password"
    private let keychain = Keychain()

    var isSet: Bool {
        if let _ = keychain[key] {
            return true
        }
        
        return false
    }
    
    func save(_ password: String, completion: (Bool, Error?) -> Void) {
        do {
            try keychain.set(password, key: key)
            completion(true, nil)
        }
        
        catch let error {
            completion(false, error)
        }
    }
    
    func isValid(_ password: String) -> Bool {
        guard let token = keychain[key] else {
            return false
        }
        
        return password == token
    }
}
