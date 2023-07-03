//
//  MyInfoButtonType.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/03.
//

import SwiftUI

enum MyInfoButtonType {
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
    
    func destination() -> some View {
        switch self {
        case .changeUserInfo:
            return EmptyView()
        case .editChallange:
            return EmptyView()
        case .setupAlert:
            return EmptyView()
        case .syncHealth:
            return EmptyView()
        case .shareApp:
            return EmptyView()
        case .sendContact:
            return EmptyView()
        case .questions:
            return EmptyView()
        case .logout:
            return EmptyView()
        case .deleteAccount:
            return EmptyView()
        }
    }
    
    
}
