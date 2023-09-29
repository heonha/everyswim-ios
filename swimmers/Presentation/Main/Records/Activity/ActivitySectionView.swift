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
    
    private lazy var activityTableview = BaseTableView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    private func layout() {
        self.addSubview(activityTitle)
        self.addSubview(activityTableview)
        
        self.backgroundColor = .systemGray4
        self.snp.makeConstraints { make in
            make.top.equalTo(self).offset(20)
            make.horizontalEdges.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        activityTitle.snp.makeConstraints { make in
            make.top.equalTo(self).inset(20)
            make.centerX.equalTo(self)
        }
        
        activityTableview.backgroundColor = .systemBlue
        
        activityTableview.snp.makeConstraints { make in
            make.top.equalTo(activityTitle.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(self).inset(22)
            make.bottom.equalTo(self)
        }
    }
    
    func getTableView() -> UITableView {
        return self.activityTableview
    }
    
}
