//
//  AuthService.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/9/23.
//

import Foundation

final class AuthService {
        
    private let appleSignService: AppleSignService
    
    var isSignIn: Bool = true
    
    init(apple: AppleSignService = .init()) {
        self.appleSignService = apple
    }
        
    
}
