//
//  DashboardView.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/25/23.
//

import UIKit
import SnapKit

final class DashboardView: BaseScrollView {
    
    // MARK: - Init
    init() {
        super.init()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    private func configure() {
        configureBase()
    }
    
    /// [Config] base View (self)
    private func configureBase() {
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.backgroundColor = .systemBackground
    }

}
