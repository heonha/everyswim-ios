//
//  MediaSection.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/7/23.
//

import Foundation

enum MediaSection: CaseIterable {
    
    case video
    case community
    
    var title: String {
        switch self {
        case .video:
            return "추천 영상"
        case .community:
            return "수영 커뮤니티"
        }
    }
    
    var subtitle: String {
        switch self {
        case .video:
            return "초보자에게 도움 되는 영상을 모아봤어요."
        case .community:
            return "수영 정보를 얻을 수 있는 곳을 모았어요."
        }
    }
    
}
