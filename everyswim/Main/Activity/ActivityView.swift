//
//  ActivityView.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/23/23.
//

import UIKit
import SnapKit
import Combine

final class ActivityView: BaseScrollView {
    
    var layoutLoaded = CurrentValueSubject<Bool, Never>(false)
    lazy var leftSwipePublisher = self.swipePublisher(direction: .left)
    lazy var rightSwipePublisher = self.swipePublisher(direction: .right)
    
    // MARK: - INIT
    init() {
        super.init()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !layoutLoaded.value {
            layoutLoaded.send(true)
        }
    }
    
    // MARK: - Configure
    private func configure() {
        
        // ScrollView
        configureScrollView()
    }
    
    private func configureScrollView() {
        isScrollEnabled = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }

}
