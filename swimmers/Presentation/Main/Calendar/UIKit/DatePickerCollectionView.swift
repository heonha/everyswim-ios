//
//  DatePickerController.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/10/23.
//

import UIKit
import SnapKit

final class DatePickerCollectionView: UICollectionView {
    
    let dayPerWeek = 7
    
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let itemWidth = Constant.deviceSize.width / CGFloat(dayPerWeek)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        super.init(frame: .zero, collectionViewLayout: layout)
        configure()
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
    }
    
    private func layout() {
        
    }
    
}
