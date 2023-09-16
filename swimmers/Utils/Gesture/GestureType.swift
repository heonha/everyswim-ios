//
//  GestureType.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/16/23.
//

import UIKit

enum GestureType {
    
    case tap(UITapGestureRecognizer = .init())
    
    func getType() -> UIGestureRecognizer {
        switch self {
        case .tap(let gesture):
            return gesture
        }
    }
    
}
