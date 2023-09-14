//
//  MyInfoView.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/14/23.
//

import UIKit
import SnapKit

final class MyInfoView: UIView {
    
    init() {
        super.init(frame: .zero)
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
    }
    
    private func layout() {
        
    }
    
}

#if DEBUG
import SwiftUI

struct MyInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            MyInfoView()
        }
    }
}
#endif

