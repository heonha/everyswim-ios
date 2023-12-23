//
//  GestureType.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/16/23.
//

import UIKit

enum GestureType {
    
    case tap(UITapGestureRecognizer = .init())
    case swipe(UISwipeGestureRecognizer = .init(), direction: UISwipeGestureRecognizer.Direction)

    func getType() -> UIGestureRecognizer {
        switch self {
        case .tap(let gesture):
            return gesture
        case .swipe(let gesture, let direction):
            gesture.direction = direction
            return gesture
        }
    }
    
}
