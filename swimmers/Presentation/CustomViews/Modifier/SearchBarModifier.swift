//
//  SearchBarModifier.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/06/25.
//

import SwiftUI

struct SearchBarModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(ThemeColor.cellBackground)
                .frame(height: 42.5)
            
            HStack(spacing: 6) {
                Image(systemName: "magnifyingglass")
                    .frame(height: 15)
                
                content
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .textCase(.none)
            }
            .padding(.horizontal)
            .foregroundColor(ThemeColor.grayTint)
        }
    }
}
//
//struct SearchBarModifier_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchBarModifier()
//    }
//}
//
//
//struct BorderedCaption: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .font(.caption2)
//            .padding(10)
//            .overlay(
//                RoundedRectangle(cornerRadius: 15)
//                    .stroke(lineWidth: 1)
//            )
//            .foregroundColor(Color.blue)
//    }
//}
