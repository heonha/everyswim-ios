//
//  CellBackground.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/08.
//

// (cornerRadius: 12, shadowRadius: 1.5, shadowOpacity: 0.12, shadowLocation: .init(x: 0.5, y: 0.5))

import SwiftUI

struct CellBackground: View {
    
    @Environment(\.colorScheme) private var colorScheme
    var cornerRadius: CGFloat = 12
    var material: Material = .ultraThinMaterial
    var shadowRadius: CGFloat = 2
    var shadowOpacity: CGFloat = 0.16
    var shadowLocation: CGPoint = .init(x: 0.5, y: 0.5)
    
    var body: some View {
        Group {
            switch colorScheme {
            case .light:
                lightBackground
            case .dark:
                darkBackground
            @unknown default:
                lightBackground
            }
        }
    }
    
    private var lightBackground: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.white)
            .shadow(color: .black.opacity(shadowOpacity), radius: shadowRadius, x: shadowLocation.y, y: shadowLocation.x)
    }
    
    private var darkBackground: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(material)
    }

}

struct CellBackground_Previews: PreviewProvider {
    static var previews: some View {
        CellBackground()
            .frame(height: 100)
    }
}
