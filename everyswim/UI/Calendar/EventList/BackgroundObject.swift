//
//  BackgroundObject.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/08.
//

import SwiftUI

struct BackgroundObject: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            switch colorScheme {
            case .light:
                lightBody
            case .dark:
                darkBody
            @unknown default:
                lightBody
            }
        }
    }
    
    var lightBody: some View {
        VStack {
            Circle()
                .fill(AppColor.labelTint)
                .scaleEffect(0.6)
                .offset(x: 20)
                .blur(radius: 150)

            Circle()
                .fill(AppColor.labelTint)
                .scaleEffect(0.6, anchor: .leading)
                .offset(y: -20)
                .blur(radius: 150)
        }
        .opacity(0.1)

    }
    
    var darkBody: some View {
        VStack {
            Circle()
                .fill(AppColor.labelTint)
                .scaleEffect(0.6)
                .offset(x: 20)
                .blur(radius: 150)

            Circle()
                .fill(AppColor.labelTint)
                .scaleEffect(0.6, anchor: .leading)
                .offset(y: -20)
                .blur(radius: 150)
        }
        .opacity(0.6)

    }
}
