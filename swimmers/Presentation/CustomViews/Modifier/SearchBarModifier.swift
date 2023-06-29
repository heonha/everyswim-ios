//
//  SearchBarModifier.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/06/25.
//

import SwiftUI

struct SearchBarModifier: ViewModifier {
    
    var clearButtonMode: UITextField.ViewMode = .whileEditing
    var fillColor: Color = ThemeColor.cellBackground
    
    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(fillColor)
                .frame(height: 42.5)
            
            HStack(spacing: 6) {
                Image(systemName: "magnifyingglass")
                    .frame(height: 15)
                
                content
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .textCase(.none)
                    .foregroundColor(.black)
            }
            .padding(.horizontal)
            .foregroundColor(ThemeColor.grayTint)
        }
        .onAppear {
            UITextField.appearance().clearButtonMode = clearButtonMode
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
