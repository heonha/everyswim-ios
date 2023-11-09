//
//  IsHidden.swift
//  everyswim
//
//  Created by HeonJin Ha on 10/8/23.
//

import Foundation

enum IsHidden {
    case show
    case hide
    
    var boolType: Bool {
        switch self {
        case .show:
            return false
        case .hide:
            return true
        }
    }
}
