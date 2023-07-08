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
    
    func getSymbolColor() -> Color {
        switch self {
        case .swim:
            return AppColor.primary
        case .kcal:
            return AppColor.caloriesRed
        case .lap:
            return Color.black
        case .speed:
            return AppColor.primary
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
        case .speed:
            return "km/h"
        }
    }
    
    
}
