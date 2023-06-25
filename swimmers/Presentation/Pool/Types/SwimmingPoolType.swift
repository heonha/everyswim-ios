//
//  SwimmingPoolType.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/06/25.
//

import Foundation

enum SwimmingPool: String {
    
    case none = ""
    case _50plus = "구로 50플러스 수영장"
    case gochukdom = "고척돔체육센터 수영장"
    case guronam = "구로남체육센터 수영장"
    
    func getImage() -> String {
        switch self {
            
        case .none:
            return ""
        case ._50plus:
            return "pool1"
        case .gochukdom:
            return "pool2"
        case .guronam:
            return "pool3"
        }
    }
    
}
