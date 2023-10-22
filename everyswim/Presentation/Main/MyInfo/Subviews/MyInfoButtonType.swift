//
//  MyInfoButtonType.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/03.
//

import SwiftUI

enum PresentType {
    case navigationLink
    case modalView
}

enum MyInfoSection {
    case first
    case second
    case third
}

enum MyInfoButtonType: CaseIterable {
    case changeUserInfo
    case editChallange
    case setupAlert
    case syncHealth
    
    case shareApp
    case sendContact
    case questions
    
    case logout
    case deleteAccount
    
    func getUIData() -> (symbolName: String, title: String) {
        switch self {
        case .changeUserInfo:
            return ("person.circle", "회원 정보 변경")
        case .editChallange:
            return ("flag.checkered", "목표 수정")
        case .setupAlert:
            return ("bell.circle", "알림 설정")
        case .syncHealth:
            return ("heart.text.square", "건강정보 연동 (워치)")
        case .shareApp:
            return ("square.and.arrow.up", "앱 공유하기")
        case .sendContact:
            return ("headphones", "문의 보내기")
        case .questions:
            return ("questionmark.circle", "도움말")
        case .logout:
            return ("door.right.hand.open", "로그아웃")
        case .deleteAccount:
            return ("exclamationmark.triangle.fill", "회원탈퇴")
        }
    }
    
    func presentType() -> PresentType {
        switch self {
        case .syncHealth:
            return .modalView
        default:
            return .navigationLink
        }
    }

}
