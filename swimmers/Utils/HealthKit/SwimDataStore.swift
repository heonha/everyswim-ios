//
//  SwimDataStore.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/15/23.
//

import SwiftUI
import Combine

final class SwimDataStore: ObservableObject {
    
    static let shared = SwimDataStore()
    
    var swimmingData = CurrentValueSubject<[SwimMainData], Never>([])
    
    private init() {
        
    }
    
    
}
