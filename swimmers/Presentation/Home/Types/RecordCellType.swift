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
    
    func symbolName() -> String {
        switch self {
        case .swim:
            return "figure.pool.swim"
        case .kcal:
            return "flame"
        case .lap:
            return "flag.checkered"
        }
    }
    
    func getSymbolColor() -> Color {
        switch self {
        case .swim:
            return ThemeColor.primary
        case .kcal:
            return ThemeColor.caloriesRed
        case .lap:
            return Color.black
        }
    }
    
    func getUnit() -> String {
        switch self {
        case .swim:
            return "Meters"
        case .kcal:
            return "Kcal"
        case .lap:
            return "Lap"
        }
    }
    
    
}
