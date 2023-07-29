//
//  BaseText.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/29.
//

import SwiftUI

struct BaseText: View {
    
    var text: String
    
    init() {
        
    }
    
    var body: some View {
        Text()
            .multilineTextAlignment(.center)
            .foregroundColor(.init(uiColor: .label))
    }
    
    typealias Body = Content
    

}

struct BaseText_Previews: PreviewProvider {
    static var previews: some View {
        BaseText()
    }
}
