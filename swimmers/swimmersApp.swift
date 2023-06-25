//
//  swimmersApp.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/06/25.
//

import SwiftUI
import NMapsMap

@main
struct swimmersApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear {
                    NMFAuthManager.shared().clientId = Keys.NAVER_CLIENT_ID
                }
        }
    }
}
