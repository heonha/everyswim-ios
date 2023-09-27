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



// private var lightBackground: some View {
//         RoundedRectangle(cornerRadius: cornerRadius)
//             .fill(Color.white)
//             .shadow(color: .black.opacity(shadowOpacity), radius: shadowRadius, x: shadowLocation.y, y: shadowLocation.x)
//     }

// struct CellBackground: View {
//     
//     @Environment(\.colorScheme) private var colorScheme
//     var cornerRadius: CGFloat = 12
//     var material: Material = .ultraThinMaterial
//     var shadowRadius: CGFloat = 1
//     var shadowOpacity: CGFloat = 0.12
//     var shadowLocation: CGPoint = .init(x: 0.5, y: 0.5)
//     
//     var body: some View {
//         Group {
//             switch colorScheme {
//             case .light:
//                 lightBackground
//             case .dark:
//                 darkBackground
//             @unknown default:
//                 lightBackground
//             }
//         }
//     }
//     
//     private var lightBackground: some View {
//         RoundedRectangle(cornerRadius: cornerRadius)
//             .fill(Color.white)
//             .shadow(color: .black.opacity(shadowOpacity), radius: shadowRadius, x: shadowLocation.y, y: shadowLocation.x)
//     }
//     
//     private var darkBackground: some View {
//         RoundedRectangle(cornerRadius: cornerRadius)
//             .fill(material)
//     }
// 
// }


extension CALayer {
    
    /// Figma와 UIKit의 Shadow 렌더링 방식에 따른 차이를 보정해주기 위한 method입니다.
    func setFigmaShadow(color: UIColor = UIColor(hex: "000000"),
                        alpha: Float = 0.5,
                        x: CGFloat = 0,
                        y: CGFloat = 2,
                        blur: CGFloat = 4,
                        spread: CGFloat = 0,
                        radius: CGFloat = 0) {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        
        shouldRasterize = true
        rasterizationScale = UIScreen.main.scale
        
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
}
