//
//  DateRecordListView.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/17/23.
//

import UIKit
import SnapKit

final class DateRecordListView: UIView {
        
    private let viewModel: DatePickerViewModel
    private var primaryColor = AppUIColor.primary

    private let tableView = UITableView()
    private lazy var recordCells: [SwimRecordSmallCell] = []
    
    private let contentView = UIView()
    
    private let title = ViewFactory
        .label("수영 기록")
        .font(.custom(.sfProMedium, size: 18))
    
    private lazy var toggleImageView = UIImageView()
        .setSymbolImage(systemName: viewModel.isMonthlyRecord 
                        ? "checkmark.circle.fill" 
                        : "circle")
        .contentMode(.scaleAspectFit)
    
    private let toggleButtonTitle = ViewFactory
        .label("월간 기록보기")
        .font(.custom(.sfProLight, size: 14))

    private lazy var monthlyToggleButton = ViewFactory
        .hStack()
        .spacing(2)
        .addSubviews([toggleImageView, toggleButtonTitle])

    private lazy var headerView = ViewFactory
        .hStack()
        .spacing(16)
        .addSubviews([title, UIView.spacer(), monthlyToggleButton])

    
    init(viewModel: DatePickerViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.backgroundColor = .systemGreen
        self.addSubview(contentView)
        self.contentView.addSubview(headerView)
        self.contentView.addSubview(tableView)
        self.tableView.separatorStyle = .none
    }
    
    private func layout() {
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        headerView.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(contentView).inset(12)
            make.height.equalTo(30)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView)
            make.bottom.equalToSuperview()
        }
        
    }
    
    func getTableView() -> UITableView {
        return self.tableView
    }
    
    func getMothlyToggleButton() -> UIView {
        return self.monthlyToggleButton
    }
    
    func monthlyToggleButtonAction() {
        viewModel.isMonthlyRecord.toggle()
        if viewModel.isMonthlyRecord {
            toggleImageView.updateSymbolImage(systemName: "checkmark.circle.fill")
        } else {
            toggleImageView.updateSymbolImage(systemName: "circle")
        }
    }
    
}

#if DEBUG
import SwiftUI

struct DateRecordListView_Previews: PreviewProvider {
    
    static let viewModel = DatePickerViewModel()
    
    static var previews: some View {
        UIViewPreview {
            DateRecordListView(viewModel: viewModel)
        }
        
        EventListView(viewModel: .init(initialValue: viewModel))
    }
}
#endif

