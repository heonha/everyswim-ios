//
//  ActivityViewController.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/29/23.
//

import UIKit
import SnapKit
import Combine

final class ActivityViewController: UIViewController, CombineCancellable {
    
    private let viewModel: ActivityViewModel
    
    var cancellables: Set<AnyCancellable> = .init()
    
    private let scrollView = BaseScrollView()
    private lazy var dateSegmentView = ActivitySegment(viewModel: viewModel)
    
    // 이번주 - 지난주 ....
    private let titleLabelMenu = ViewFactory.label("이번 주")
        .font(.custom(.sfProBold, size: 17))
        .foregroundColor(.secondaryLabel)
    
    private lazy var distanceStack = DistanceBigLabel()
    
    private lazy var recordHStack = RecordHStackView()
    
    private lazy var recordMainStack = ViewFactory.vStack()
        .addSubviews([titleLabelMenu, distanceStack, recordHStack])
        .spacing(30)
        .alignment(.center)
        .distribution(.fillProportionally)
    
    private lazy var mainVStack = ViewFactory.vStack()
        .addSubviews([dateSegmentView, recordMainStack, graphView])
        .spacing(30)
        .alignment(.center)
        .distribution(.fillProportionally)
    
    // 주간 그래프
    private lazy var graphView = UIView()
    
    // 주간 활동
    private lazy var activitySectionView = ActivitySectionView()
    
    init(viewModel: ActivityViewModel = .init()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    private func configure() {
        // 이번주 기록 가져오기
        recordHStack.setData(viewModel.summaryData)
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func configureTableView() {
        let tableView = activitySectionView.getTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RecordMediumCell.self, forCellReuseIdentifier: RecordMediumCell.reuseId)
    }
    
    private func layout() {
        view.addSubview(scrollView)
        let contentView = scrollView.contentView
        contentView.addSubview(mainVStack)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        mainVStack.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(16)
            make.horizontalEdges.equalTo(contentView)
            make.centerX.equalTo(contentView)
        }
        
        dateSegmentView.snp.makeConstraints { make in
            make.width.equalTo(mainVStack).inset(32)
            make.height.equalTo(30)
        }

        recordHStack.snp.makeConstraints { make in
            make.width.equalTo(mainVStack).inset(30)
            make.height.equalTo(70)
        }
        
        graphView.backgroundColor = .systemGray2
        graphView.snp.makeConstraints { make in
            make.height.equalTo(180)
            make.width.equalTo(mainVStack).inset(18)
        }
        
        contentView.addSubview(activitySectionView)

        activitySectionView.snp.makeConstraints { make in
            make.top.equalTo(graphView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
        
    }
    
    private func bind() {
        
        viewModel.$selectedSegment
            .receive(on: RunLoop.main)
            .sink { [weak self] tag in
                print(tag)
                guard let self = self else { return }
                let selectedView = self.dateSegmentView.getSegment()
                    .subviews
                    .first { $0.tag == tag }
                
                guard let selectedView = selectedView else { return }
                
                self.resetButtonAppearance()
                self.setHighlight(selectedView)
                viewModel.getWeeklyData(dateRange: Date())
            }
            .store(in: &cancellables)
        
        viewModel.$summaryData
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                self?.distanceStack.setData(data?.distance)
                self?.recordHStack.setData(data)
            }
            .store(in: &cancellables)
        
        viewModel.$presentedData.receive(on: RunLoop.main)
            .sink { data in
                print("리로드!")
                self.activitySectionView.getTableView().reloadData()
            }
            .store(in: &cancellables)
    }
    
    func setHighlight<T: UIView>(_ view: T) {
        let view = view as! UILabel
        view.textColor = .white
        view.backgroundColor = AppUIColor.primaryBlue
    }
    
    func resetButtonAppearance() {
        dateSegmentView.getSegment()
            .subviews
            .forEach { view in
            let view = view as! UILabel
            view.textColor = .label
            view.backgroundColor = .systemGray6
        }
    }
    
}

extension ActivityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.presentedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordMediumCell.reuseId, for: indexPath) as? RecordMediumCell else {
            return EmptySwimSmallCell()
        }
        
        let data = viewModel.presentedData[indexPath.row]
        cell.setData(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 171
    }
    
}

#if DEBUG
import SwiftUI

struct ActivityViewController_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            ActivityViewController()
        }
        .ignoresSafeArea()
    }
}
#endif

