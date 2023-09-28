//
//  BaseTableView.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/28/23.
//

import UIKit

final class BaseTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.hideSeparate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
