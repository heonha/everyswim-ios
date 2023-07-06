//
//  Kcal.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/04.
//

import Foundation

struct HealthStatus: Identifiable {
    let id = UUID()
    let count: Double
    let date: Date
}

struct Stroke: Identifiable {
    let id = UUID()
    let count: Double
    let date: Date
}
