//
//  AppImage.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/16/23.
//

import UIKit


enum AppImage {
    
    case appleHealth
    case defaultUserProfileImage
    
    // Symbol
    case listbulletRectangle
    case calendar
    case personCircleFill
    case swim
    
    func getImage() -> UIImage {
        switch self {
        case .appleHealth:
            return UIImage(named: "AppleHealth") ?? UIImage()
        case .defaultUserProfileImage:
            return UIImage(named: "defaultUser") ?? UIImage()
        case .listbulletRectangle:
            return UIImage(systemName: "list.bullet.rectangle")!
        case .calendar:
            return UIImage(systemName: "calendar")!
        case .swim:
            return UIImage(systemName: "figure.pool.swim") ?? UIImage()
        case .personCircleFill:
            return UIImage(systemName: "person.circle.fill")!
            
        }
    }
}
