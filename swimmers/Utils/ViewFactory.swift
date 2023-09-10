//
//  ViewFactory.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/27/23.
//

import UIKit

enum ViewFactory {
    
    static func vStack(subviews: [UIView],
                       spacing: CGFloat = 4,
                       alignment: UIStackView.Alignment = .fill,
                       distribution: UIStackView.Distribution = .fill) -> UIStackView {
        let sv = UIStackView(arrangedSubviews: subviews)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = spacing
        sv.alignment = alignment
        sv.distribution = distribution
        return sv
    }
    
    static func hStack(subviews: [UIView],
                       spacing: CGFloat = 4,
                       alignment: UIStackView.Alignment = .fill,
                       distribution: UIStackView.Distribution = .fill) -> UIStackView {
        let sv = UIStackView(arrangedSubviews: subviews)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = spacing
        sv.alignment = alignment
        sv.distribution = distribution
        return sv
    }
    
    
    static func label(_ text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .custom(.sfProBold, size: 16)
        label.textColor = .label
        
        return label
    }
    
}
