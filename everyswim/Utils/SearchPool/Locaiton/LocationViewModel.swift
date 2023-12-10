//
//  LocationViewModel.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/10/23.
//

import Foundation

class LocationsViewModel {
    
    @Published var locations: [Location]
    
    init() {
        self.locations =  []
    }
    
}
