//
//  DashboardView.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/25/23.
//

import UIKit
import SnapKit

final class DashboardView: BaseScrollView {
    
    private let viewModel: DashboardViewModel
    private weak var parentVC: DashboardViewController?
    
    /// `상단 헤더 뷰` (프로필)
    lazy var headerView = DashboardHeaderView(viewModel: viewModel, parentVC: parentVC)
    
    /// `최근 운동 기록 Views`
    private lazy var recentRecordView = ViewFactory
        .vStack(subviews: [eventTitle, lastWorkoutCell])
        .distribution(.fill)
        .alignment(.center)
        .spacing(4)
    
    /// [최근 운동 기록] Views - `title`
    private let eventTitle = ViewFactory
        .label("최근 기록")
        .font(.custom(.sfProLight, size: 15))
        .foregroundColor(.gray)
        .textAlignemnt(.left)
    
    /// [최근 운동 기록] `Cell`
    private lazy var lastWorkoutCell = RecordSmallCell(data: viewModel.lastWorkout ?? TestObjects.swimmingData.first!, showDate: true)
    
    /// `목표 현황` View
    private var challangeViews = ChallangeCellContainer()
    
    /// 섹션 종류
    var recommandSections = RecommandSection.allCases
    
    /// 추천 CollectionView
    private lazy var recommandCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            self.parentVC?.createBasicListLayout(section: sectionIndex)
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        return collectionView
    }()
    
    // MARK: - Init
    init(viewModel: DashboardViewModel, parentVC: DashboardViewController?) {
        self.viewModel = viewModel
        self.parentVC = parentVC
        super.init()
        configure()
        layout()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    private func configure() {
        configureBase()
        configureRecommandCollectionView()
    }
    
    /// [Config] base View (self)
    private func configureBase() {
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.isPagingEnabled = true
        self.backgroundColor = .systemBackground
    }
    
    /// [Config] CollectionView
    private func configureRecommandCollectionView() {
        recommandCollectionView.dataSource = parentVC
        recommandCollectionView.delegate = parentVC

        recommandCollectionView.register(RecommandCollectionViewHeader.self,
                                         forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                         withReuseIdentifier: RecommandCollectionViewHeader.reuseId)
        recommandCollectionView.register(RecommandVideoReusableCell.self,
                                         forCellWithReuseIdentifier: RecommandVideoReusableCell.reuseId)
        recommandCollectionView.register(CommunityReusableCell.self,
                                         forCellWithReuseIdentifier: CommunityReusableCell.reuseId)
    }

    // MARK: - Observe
    private func observe() {
        observeUpdateProfile()
        observeRecommandVideoSucceed()
        observeRecommandCommunitySucceed()
        observeLastWorkout()
        observeLastWorkoutGesture()
    }
    
    /// 프로필 업데이트
    private func observeUpdateProfile() {
        AuthManager.shared.isSignIn
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.headerView.setProfileData()
            }
            .store(in: &cancellables)
    }
    
    /// 추천 비디오 로드 완료시 리로드
    private func observeRecommandVideoSucceed() {
        viewModel.$recommandVideoSuccessed
            .receive(on: DispatchQueue.global())
            .sink { [weak self] value in
                DispatchQueue.main.async {
                    if value {
                        self?.recommandCollectionView.reloadData()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    /// 추천 커뮤니티 로드 완료시 리로드
    private func observeRecommandCommunitySucceed() {
        viewModel.$recommandCommunitySuccessed
            .receive(on: DispatchQueue.global())
            .sink { [weak self] value in
                DispatchQueue.main.async {
                    if value {
                        self?.recommandCollectionView.reloadData()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    /// 최근 운동기록 데이터 업데이트
    private func observeLastWorkout() {
        viewModel.$lastWorkout
            .receive(on: DispatchQueue.main)
            .sink {[unowned self] data in
                if let data = data {
                    lastWorkoutCell.updateData(data)
                }
            }
            .store(in: &cancellables)
    }
    
    private func observeLastWorkoutGesture() {
        // 최근 운동기록 제스쳐
        lastWorkoutCell.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let data = self?.viewModel.lastWorkout else { return }
                
                let detailVC = ActivityDetailViewController(data: data)
                self?.parentVC?.push(detailVC, animated: true)
            }
            .store(in: &cancellables)

    }

    // MARK: - Layout
    private func layout() {
        let spacing: CGFloat = 28
        layoutHeaderView(height: 80)
        layoutRecentRecordView(height: 100)
        layoutChallangeViews(spacing: spacing, height: 220)
        layoutRecommandCollectionView(spacing: spacing, height: 600)
    }
    
    /// [Layout] HeaderView
    private func layoutHeaderView(height: CGFloat) {
        contentView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.height.equalTo(height)
        }
    }

    /// [Layout] RecentRecordView
    private func layoutRecentRecordView(height: CGFloat) {
        contentView.addSubview(recentRecordView)
        
        recentRecordView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(4)
            make.height.equalTo(height)
            make.horizontalEdges.equalTo(contentView).inset(20)
        }
        
        eventTitle.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(recentRecordView)
        }
        
        lastWorkoutCell.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(recentRecordView)
        }
    }
    
    /// [Layout] ChallangeView
    private func layoutChallangeViews(spacing: CGFloat, height: CGFloat) {
        contentView.addSubview(challangeViews)
        
        challangeViews.snp.makeConstraints { make in
            make.top.equalTo(recentRecordView.snp.bottom).offset(8)
            make.height.equalTo(height)
            make.horizontalEdges.equalTo(contentView).inset(20)
        }
    }
    
    /// [Layout] RecommandCollectionView
    private func layoutRecommandCollectionView(spacing: CGFloat,
                                               height: CGFloat) {
        contentView.addSubview(recommandCollectionView)
        recommandCollectionView.isScrollEnabled = false
        recommandCollectionView.snp.makeConstraints { make in
            make.top.equalTo(challangeViews.snp.bottom).offset(spacing)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.height.equalTo(height)
            make.bottom.equalTo(contentView)
        }

    }
    
    // MARK: - Update UI
    private func updateChallangeView() {
        challangeViews.startCircleAnimation()
    }
    
}
