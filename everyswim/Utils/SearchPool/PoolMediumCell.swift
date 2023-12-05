//
//  PoolMediumCell.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/3/23.
//

import UIKit
import SnapKit

struct Pool {
  let name: String
  let address: String
}


final class PoolMediumCell: UITableViewCell, ReuseableObject {
    
    static var reuseId: String = "PoolMediumCell"
    
    private var titleLabel = ViewFactory
        .label("수영장")
        .font(.custom(.sfProBold, size: 16))
        .textAlignemnt(.left)
    
    private var addressLabel = ViewFactory
        .label("서울시 구로구")
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
        contentView.backgroundColor = UIColor(hex: "92B9E7", alpha: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: Pool) {
        self.titleLabel.text = data.name
        self.addressLabel.text = data.address
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

// MARK: - Preview
#if DEBUG
import SwiftUI

struct PoolMediumCell_Previews: PreviewProvider {
    
    static let view = PoolMediumCell()
    static let data = Pool(name: "구로 50플러스 수영장", 
                           address: "서울특별시 구로구 오류로 36-25 50플러스남부캠퍼스(지하2층)")
    
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

