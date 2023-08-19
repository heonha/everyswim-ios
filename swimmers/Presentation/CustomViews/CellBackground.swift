//
//  CellBackground.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/08.
//

import SwiftUI

struct CellBackground: View {
    
    @Environment(\.colorScheme) private var colorScheme
    var cornerRadius: CGFloat = 25
    var material: Material = .ultraThinMaterial
    var shadowRadius: CGFloat = 4
    var shadowOpacity: CGFloat = 0.20
    var shadowLocation: CGPoint = .init(x: 1, y: 1)
    
    var body: some View {
        Group {
            switch colorScheme {
            case .light:
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(shadowOpacity), radius: shadowRadius, x: shadowLocation.y, y: shadowLocation.x)
            case .dark:
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(material)
            @unknown default:
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(shadowOpacity), radius: shadowRadius, x: shadowLocation.x, y: shadowLocation.y)
            }
        }
    }

}

struct CellBackground_Previews: PreviewProvider {
    static var previews: some View {
        CellBackground()
    }
}
