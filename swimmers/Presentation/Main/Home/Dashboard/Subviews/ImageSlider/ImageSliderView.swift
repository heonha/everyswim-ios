//
//  ImageSliderController.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/9/23.
//

import UIKit
import SnapKit

final class ImageSliderView: UICollectionView {
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.backgroundColor = .white
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.isPrefetchingEnabled = true
        self.allowsSelection = false
        self.selectionFollowsFocus = false
        self.isPagingEnabled = true
    }
    
}

#if DEBUG
import SwiftUI

struct ImageSliderView_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            ImageSliderView()
        }
        .frame(height: 300)
    }
}
#endif
