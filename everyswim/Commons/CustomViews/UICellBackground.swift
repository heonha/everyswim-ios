//
//  UICellBackground.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/7/23.
//

import UIKit
import SnapKit

final class UICellBackground: UIView {
    
    private var cornerRadius: CGFloat
    private var color: UIColor
    private var shadowRadius: CGFloat
    private var shadowOpacity: CGFloat
    private var shadowLocation: CGPoint
        
    init(cornerRadius: CGFloat = 12,
         color: UIColor = .white,
         shadowRadius: CGFloat = 2,
         shadowOpacity: CGFloat = 0.2,
         shadowLocation: CGPoint = .init(x: 0, y: 0)) {
        
        self.cornerRadius = cornerRadius
        self.color = color
        self.shadowRadius = shadowRadius
        self.shadowOpacity = shadowOpacity
        self.shadowLocation = shadowLocation
        super.init(frame: .zero)
        draw()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func draw() {
        self.backgroundColor = .white
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = cornerRadius
        view.layer.setFigmaShadow(color: .black, alpha: Float(shadowOpacity), x: shadowLocation.x, y: shadowLocation.y, blur: shadowRadius, radius: shadowRadius)
        
        self.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(shadowRadius)
        }
    }

}

#if DEBUG
import SwiftUI

struct UICellBackground_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            UICellBackground()
        }
        .frame(width: 100, height: 100)
    }
}
#endif
