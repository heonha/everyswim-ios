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
    private let titleLabel = ViewFactory.label("이번 주")
        .font(.custom(.sfProBold, size: 17))
        .foregroundColor(.secondaryLabel)
    
    private let titleLabelSybmol = UIImageView()
        .setSymbolImage(systemName: "chevron.down", color: AppUIColor.grayTint)
        .contentMode(.scaleAspectFit)
        .setSize(width: 20, height: 20)
    
    private lazy var titleMenu = ViewFactory.hStack()
        .addSubviews([titleLabel, titleLabelSybmol])
        .spacing(4)
        .alignment(.center)
        .distribution(.fillProportionally)
    
    private lazy var distanceStack = DistanceBigLabel()
    
    private lazy var recordHStack = RecordHStackView()
    
    private lazy var recordMainStack = ViewFactory.vStack()
        .addSubviews([titleMenu, distanceStack, recordHStack])
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
    
    private lazy var tableView = BaseTableView()

    
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
        configureTableView()
        bind()
        self.viewModel.selectedSegment = 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.title = "수영 기록"
        self.hideNavigationBar(false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hideNavigationBar(true)
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RecordMediumCell.self, forCellReuseIdentifier: RecordMediumCell.reuseId)
        tableView.backgroundColor = .systemGray6
        tableView.isScrollEnabled = false
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
        
        distanceStack.snp.makeConstraints { make in
            make.height.equalTo(100)
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
            make.height.equalTo(50)
        }
        
        activitySectionView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(activitySectionView.snp.bottom)
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
                
                guard let selectedView = selectedView as? UILabel else { return }
                
                self.resetButtonAppearance()
                self.setHighlight(selectedView)
                self.titleLabelSybmol.isHidden = false
                switch tag {
                case 0:
                    self.titleLabel.text = "오늘"
                    self.activitySectionView.updateTitle("오늘의 수영")
                case 1:
                    self.titleLabel.text = "이번 주"
                    self.activitySectionView.updateTitle("주간 수영 기록")
                case 2:
                    let month = Date().toString(.monthKr)
                    self.titleLabel.text = "\(month)"
                    self.activitySectionView.updateTitle("\(month)의 수영")
                case 3:
                    self.titleLabel.text = "전체 기록"
                    self.titleLabelSybmol.isHidden = true
                    self.activitySectionView.updateTitle("전체 수영기록")
                default:
                    return
                }
                
            }
            .store(in: &cancellables)
        
        viewModel.$summaryData
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                self?.distanceStack.setData(data?.distance)
                self?.recordHStack.setData(data)
            }
            .store(in: &cancellables)
        
        viewModel.$presentedData
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                self?.tableView.reloadData()
                self?.updateTableViewSize()
            }
            .store(in: &cancellables)
        
        titleMenu.gesturePublisher(.tap())
            .receive(on: RunLoop.main)
            .sink { _ in
                print("팝업!")
            }
            .store(in: &cancellables)
    }
    
    func updateTableViewSize() {
        var count = viewModel.presentedData.count
        if count == 0 {
            count = 1
        }
        
        let cellHeight = 180.0
        
        let maxSize = CGFloat(count) * cellHeight
        
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(activitySectionView.snp.bottom)
            make.horizontalEdges.equalTo(scrollView.contentView)
            make.height.equalTo(maxSize)
        }
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
        if viewModel.presentedData.isEmpty {
            return 1
        } else {
            return viewModel.presentedData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.presentedData.isEmpty {
            return EmptyRecordCell.withType(.normal)
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordMediumCell.reuseId, for: indexPath) as? RecordMediumCell else {
            return EmptyRecordCell()
        }
        
        let data = viewModel.presentedData[indexPath.row]
        cell.setData(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 171
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? RecordMediumCell else {return}
        let data = cell.getData()
        let detailVC = RecordDetailViewController(data: data)
        self.push(detailVC, animated: true)
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
