//
//  RegionListCell.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/3/23.
//

import UIKit
import SnapKit

final class RegionListCell: UITableViewCell, ReuseableObject {
    
    static var reuseId: String = "RegionListCell"
    
    private let cellBackground = UIView()
    
    private var titleLabel = ViewFactory
        .label("서울특별시")
        .font(.custom(.sfProMedium, size: 17))
        .textAlignemnt(.left)
    
    private var rightImageView = UIImageView()
        .setSymbolImage(systemName: "chevron.right", color: .secondaryLabel)
        .contentMode(.scaleAspectFit)

    private lazy var labelHStack = ViewFactory.hStack()
        .addSubviews([titleLabel, rightImageView])
        .distribution(.fillProportionally)
        .alignment(.center)
    
    // MARK: - Init & LifeCycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
        contentView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configures
    func configure(title: String) {
        self.titleLabel.text = title
    }
    
    // MARK: - Layout
    private func layout() {
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        contentView.addSubview(cellBackground)
        
        cellBackground.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView).inset(8)
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.center.equalTo(contentView)
        }
        
        cellBackground.addSubview(labelHStack)
        
        labelHStack.snp.makeConstraints { make in
            make.verticalEdges.equalTo(cellBackground)
            make.horizontalEdges.equalTo(cellBackground)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.horizontalEdges.equalTo(labelHStack)
        }

        rightImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.trailing.equalTo(cellBackground)
        }

    }

}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct LocationCell_Previews: PreviewProvider {
    
    static let view = RegionListCell()
    static let data = Region(code: "11", name: "서울시", districts: ["강남구", "강동구", "강서구", "관악구", "구로구", "도봉구", "동대문구", "동작구", "마포구", "서대문구", "성동구", "성북구", "영등포구", "용산구", "은평구", "종로구", "중구", "송파구", "중랑구", "양천구", "서초구", "노원구", "광진구", "강북구", "금천구"])
    
    static var previews: some View {
        UIViewPreview {
            view
        }
        .frame(height: 50)
        .frame(width: 393)
        .onAppear {
            view.configure(title: "서울시")
        }
    }
}
#endif

