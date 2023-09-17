//
//  AppSymbol.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/08.
//

import SwiftUI

enum AppSymbol {
    case swim
    case swimWave
    case flare
    case logout
    case targetEdit
}


extension AppSymbol {
    
    func getSymbol(size: CGSize, color: UIColor) -> UIImage? {
        switch self {
        case .swim:
            return UIImage(named: "swim")
//        case .swimWave:
//            return UIImage(named: "swimWave") ?? UIImage()
        case .flare:
            return UIImage(named: "flame")
//        case .logout:
//            return UIImage(named: "logout") ?? UIImage()
//        case .targetEdit:
//            return UIImage(named: "targetEdit") ?? UIImage()
        default:
            return UIImage()
        }
    }
    
}
