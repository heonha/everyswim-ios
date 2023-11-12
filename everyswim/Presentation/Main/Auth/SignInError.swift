//
//  SignInError.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/10/23.
//

import Foundation

enum SignInError: Error {
    
    /// 알 수 없는 에러
    case unknown
    /// 로그인은 성공했으나 유저 데이터를 가져올 수 없음
    case userdataFetchError
    
    /// currentNounce가 생성되지 않았습니다. (nil)
    case invalidNounce
    
    /// 토큰 가져오기 실패
    case failFetchToken
    
    /// 토큰 파싱 실패 (utf8)
    case failTokenPasing(message: String)
    
    /// AppleId Credential이 확인되지 않음
    case failToFetchAppleIDCredential
    
    /// 세션이 만료 됨.
    case sessionExpired
}
