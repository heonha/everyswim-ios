//
//  PoolMediumCell.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/3/23.
//

import UIKit
import SnapKit

final class PoolMediumCell: UITableViewCell, ReuseableObject {
    
    static var reuseId: String = "PoolMediumCell"
    
    private var titleLabel = ViewFactory
        .label("000 수영장")
        .font(.custom(.sfProBold, size: 16))
        .textAlignemnt(.left)
    
    private var addressLabel = ViewFactory
        .label("--시 --구 --동")
        .font(.custom(.sfProLight, size: 14))
        .foregroundColor(.secondaryLabel)
        .textAlignemnt(.left)
    
    private lazy var labelVStack = ViewFactory.vStack()
        .addSubviews([titleLabel, addressLabel, UIView.spacer()])
        .alignment(.firstBaseline)
        .distribution(.fillProportionally)
    
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
    
    func configure(data: KakaoPlace) {
        self.titleLabel.text = data.placeName
        self.addressLabel.text = data.roadAddressName
    }
    
    private func layout() {
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        contentView.addSubview(labelVStack)
        
        labelVStack.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView).inset(4)
            make.horizontalEdges.equalTo(contentView).inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.horizontalEdges.equalTo(labelVStack)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.height.equalTo(40).priority(.low)
            make.horizontalEdges.equalTo(labelVStack)
        }

    }
    
}

// MARK: - Test Stub
extension PoolMediumCell {
#if targetEnvironment(simulator)

    func configureForUITest(name: String, address: String) {
        self.titleLabel.text = name
        self.addressLabel.text = address
    }
    
#endif
}


// MARK: - Preview
#if targetEnvironment(simulator)
import SwiftUI

struct PoolMediumCell_Previews: PreviewProvider {
    
    static let view = PoolMediumCell()
    
    static var previews: some View {
        UIViewPreview {
            view
        }
        .frame(height: 60)
        .frame(width: 393)
        .onAppear {
            view.configureForUITest(name: "수영장", address: "서울시 구로구")
        }
    }
}
#endif
