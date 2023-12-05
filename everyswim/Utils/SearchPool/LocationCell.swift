//
//  LocationCell.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/3/23.
//

import UIKit
import SnapKit

final class LocationCell: UITableViewCell, ReuseableObject {
    
    static var reuseId: String = "LocationCell"
    
    private var titleLabel = ViewFactory
        .label("현위치")
        .font(.custom(.sfProBold, size: 16))
        .textAlignemnt(.left)
    
    private var rightImageView = UIImageView()
        .setImage(AppImage.chevronRight.getImage())
        .contentMode(.scaleAspectFit)

    private lazy var labelHStack = ViewFactory.vStack()
        .addSubviews([titleLabel, rightImageView])
        .alignment(.center)
        .distribution(.fillProportionally)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
        contentView.backgroundColor = UIColor(hex: "92B9E7", alpha: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: String) {
        self.titleLabel.text = "현위치: \(data)"
    }
    
    private func layout() {
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        contentView.addSubview(labelHStack)
        
        labelHStack.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView).inset(4)
            make.horizontalEdges.equalTo(contentView).inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.horizontalEdges.equalTo(labelHStack)
        }
        
        rightImageView.snp.makeConstraints { make in
            make.size.equalTo(40).priority(.high)
            make.horizontalEdges.equalTo(labelHStack)
        }
    }
    
}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct LocationCell_Previews: PreviewProvider {
    
    static let view = LocationCell()
    static let data = "서울시"
    
    static var previews: some View {
        UIViewPreview {
            view
        }
        .frame(height: 60)
        .frame(width: 393)
        .onAppear {
            view.configure(data: data)
        }
    }
}
#endif

