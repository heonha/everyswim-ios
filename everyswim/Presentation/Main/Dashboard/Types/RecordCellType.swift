//
//  RecordCellType.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/06/25.
//

import SwiftUI

enum RecordCellType: String {
    case swim
    case kcal
    case lap
    case speed
    
    func symbolName() -> String {
        switch self {
        case .swim:
            return "figure.pool.swim"
        case .kcal:
            return "flame"
        case .lap:
            return "flag.checkered"
        case .speed:
            return "water.waves"
        }
    }
    
    func getUnit() -> String {
        switch self {
        case .swim:
            return "meters"
        case .kcal:
            return "kcal"
        case .lap:
            return "Lap"
        case .speed:
            return "km/h"
        }
    }
    
    
}
