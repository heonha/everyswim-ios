//
//  SignInViewModel.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/9/23.
//

import UIKit
import AuthenticationServices

class SignInViewModel: ObservableObject {
    
    private struct Constant {
        static let appleUserIdentifierKey = "appleUserIdentifierKey"
    }
    
    private let keychainService = KeyChainService()
    
    
    
    func saveUserInKeychain(_ userIdentifier: String) {
        keychainService.save(key: Constant.appleUserIdentifierKey, value: userIdentifier)
    }

    
}
