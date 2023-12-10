//
//  RegionListCell.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/3/23.
//

import UIKit
import SnapKit

final class RegionListCell: UITableViewCell, ReuseableObject {
    
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
    
    func configure(data: Region) {
        self.titleLabel.text = "현위치: \(data.name)"
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
    
    static let view = RegionListCell()
    static let data = Region(code: "11", name: "서울", districts: ["강남구", "강동구", "강서구", "관악구", "구로구", "도봉구", "동대문구", "동작구", "마포구", "서대문구", "성동구", "성북구", "영등포구", "용산구", "은평구", "종로구", "중구", "송파구", "중랑구", "양천구", "서초구", "노원구", "광진구", "강북구", "금천구"])
    
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

