//
//  AppImage.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/16/23.
//

import UIKit


enum AppImage {
    
    case appleHealth
    
    func getImage() -> UIImage {
        switch self {
        case .appleHealth:
            return UIImage(named: "AppleHealth") ?? UIImage()
        }
    }
}
