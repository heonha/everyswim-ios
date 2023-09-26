//
//  DatePickerFlowLayout.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/17/23.
//

import UIKit

enum FlowLayout {
    
    case datePicker
    
    func get(cellSize: CGSize) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return layout
    }
    
}
