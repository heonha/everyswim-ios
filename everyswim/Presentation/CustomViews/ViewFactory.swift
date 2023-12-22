//
//  ViewFactory.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/27/23.
//

import UIKit
import SnapKit

enum ViewFactory {
    
    static func vStack(subviews: [UIView] = [],
                       spacing: CGFloat = 4,
                       alignment: UIStackView.Alignment = .fill,
                       distribution: UIStackView.Distribution = .fill) -> UIStackView {
        let sv = UIStackView(arrangedSubviews: subviews)
        sv.axis = .vertical
        sv.spacing = spacing
        sv.alignment = alignment
        sv.distribution = distribution
        return sv
    }
    
    static func hStack(subviews: [UIView] = [],
                       spacing: CGFloat = 4,
                       alignment: UIStackView.Alignment = .fill,
                       distribution: UIStackView.Distribution = .fill) -> UIStackView {
        let sv = UIStackView(arrangedSubviews: subviews)
        sv.axis = .horizontal
        sv.spacing = spacing
        sv.alignment = alignment
        sv.distribution = distribution
        return sv
    }
    
    static func label(_ text: String = "") -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .custom(.sfProBold, size: 16)
        label.textColor = .label
        
        return label
    }
    
    static func buttonWithText1(_ text: String) -> UILabel {
        let button = ViewFactory
            .label(text)
            .font(.custom(.sfProBold, size: 18))
            .textAlignemnt(.center)
            .foregroundColor(.white)
            .backgroundColor(AppUIColor.secondaryBlue)
            .cornerRadius(4) as! UILabel
        
        button.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        return button
    }
    
}
