//
//  PoolInfoMediumCell.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/3/23.
//

import UIKit
import SnapKit

final class PoolInfoMediumCell: UITableViewCell, ReuseableObject {
    
    // MARK: Properties
    static var reuseId: String = "PoolInfoMediumCell"
    
    // MARK: StackViews
    
    private lazy var mainHStack = ViewFactory
        .hStack()
        .addSubviews([markerImageView, labelsVStack, distanceLabel])
        .spacing(4)
        .alignment(.top)
        .distribution(.fill)
    
    private lazy var labelsVStack = ViewFactory
        .vStack()
        .addSubviews([titleLabel, addressLabel])
        .alignment(.leading)
        .distribution(.fill)

    // MARK: SubViews
    private let markerImageView = UIImageView()
        .setSize(width: 32, height: 24)
        .setSymbolImage(systemName: "figure.pool.swim", color: .secondaryLabel)
        .contentMode(.scaleAspectFit)
    
    private var titleLabel = ViewFactory
        .label("000 수영장")
        .font(.custom(.sfProBold, size: 16))
        .textAlignemnt(.left)
    
    private var addressLabel = ViewFactory
        .label("--시 --구 --동")
        .font(.custom(.sfProLight, size: 14))
        .foregroundColor(.secondaryLabel)
        .textAlignemnt(.left)
    
    private var distanceLabel = ViewFactory
        .label("--- m")
        .font(.custom(.sfProLight, size: 14))
        .foregroundColor(.secondaryLabel)
        .textAlignemnt(.right)

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
        configureCell()
    }
    
    private func configureCell() {
        self.backgroundColor = .systemBackground

    }

    private func layout() {
        contentView.addSubview(mainHStack)
        
        // MainHStack
        mainHStack.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView).inset(4)
            make.horizontalEdges.equalTo(contentView).inset(16)
        }
        
        // 마커 이미지
        markerImageView.snp.makeConstraints { make in
            make.width.equalTo(32)
            make.height.equalTo(titleLabel)
            make.centerY.equalTo(titleLabel)
        }
        
        // 수영장 이름
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        
        // 주소 라벨
        addressLabel.snp.makeConstraints { make in
            make.height.equalTo(40).priority(.low)
            make.leading.equalTo(titleLabel)
        }
        
        // 현위치로부터의 거리
        distanceLabel.snp.makeConstraints { make in
            make.height.equalTo(titleLabel)
            make.centerY.equalTo(titleLabel)
            make.width.equalTo(70)
        }
    }
    
    // MARK: - Configure
    func configure(data: MapPlace) {
        self.titleLabel.text = data.placeName
        self.distanceLabel.text = data.distanceWithUnit()
        
        self.addressLabel.text = data.roadAddressName
        if data.roadAddressName.isEmpty {
            self.addressLabel.text = data.addressName
        }
        
    }
    
}

// MARK: - Test Stub
extension PoolInfoMediumCell {
#if targetEnvironment(simulator)

    func configureForUITest(name: String, address: String, distnace: String) {
        self.titleLabel.text = name
        self.addressLabel.text = address
        self.distanceLabel.text = distnace
    }
    
#endif
}

// MARK: - Preview
#if targetEnvironment(simulator)
import SwiftUI

struct PoolMediumCell_Previews: PreviewProvider {
    
    static let view = PoolInfoMediumCell()
    static let view2 = PoolInfoMediumCell()
    static let view3 = PoolInfoMediumCell()

    static var previews: some View {
        
        VStack {
            UIViewPreview {
                view
                    .shadow()
            }
            .frame(height: 60)
            .frame(width: 393)
            .onAppear {
                view.configureForUITest(name: "부천시남부수자원생태공원 물놀이장에 있는 수영장",
                                        address: "경기도 부천시 어떤구 어떤동 어떤로의 몇번 수영장",
                                        distnace: "200.0 km")
                
            }
            
            UIViewPreview {
                view2
                    .shadow()
            }
            .frame(height: 60)
            .frame(width: 393)
            .onAppear {
                view2.configureForUITest(name: "부천시남부수자원생태공원 물놀이장에 있는 수영장",
                                        address: "",
                                        distnace: "200.0 km")
            }
            
            UIViewPreview {
                view3
                    .shadow()
            }
            .frame(height: 60)
            .frame(width: 393)
            .onAppear {
                view3.configureForUITest(name: "부천시남부수자원생태공원",
                                         address: "경기도 부천시",
                                         distnace: "2.0 km")
            }
        }

    }
}
#endif
