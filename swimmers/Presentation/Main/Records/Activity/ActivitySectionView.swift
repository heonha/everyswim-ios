//
//  ActivitySectionView.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/29/23.
//

import UIKit
import SnapKit

final class ActivitySectionView: UIView {
    
    // 주간활동 tableview
    private let activityTitle = ViewFactory.label("주간 활동")
        .font(.custom(.sfProLight, size: 18))
        .foregroundColor(.label)
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    private func layout() {
        self.addSubview(activityTitle)
        
        self.backgroundColor = .systemGray6
        
        activityTitle.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
        
    }
    
}
