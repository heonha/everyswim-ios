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
    var body: some View {
        Group {
            switch colorScheme {
            case .light:
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.20), radius: 4, x: 1, y: 1)
            case .dark:
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(material)
            @unknown default:
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.20), radius: 4, x: 1, y: 1)
            }
        }
    }

}

struct CellBackground_Previews: PreviewProvider {
    static var previews: some View {
        CellBackground()
    }
}
