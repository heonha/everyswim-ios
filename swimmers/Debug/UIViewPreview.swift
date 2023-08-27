//
//  UIViewPreview.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/27/23.
//

import SwiftUI

final class UIViewPreview: UIViewRepresentable {
    
    let view: UIView
    
    init(view: UIView) {
        self.view = view
    }
    
    func makeUIView(context: Context) -> UIView {
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
    
}

#if DEBUG
struct UIViewPreview_Previews: PreviewProvider {
    
    static let view = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    static var previews: some View {
        UIViewPreview(view: view)
    }
}
#endif
