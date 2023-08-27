//
//  UIViewControllerPreview.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/27/23.
//

import SwiftUI

final class UIViewControllerPreview: UIViewControllerRepresentable {
    
    let vc: UIViewController
    
    init(vc: UIViewController) {
        self.vc = vc
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    
}
