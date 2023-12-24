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
    
    /// 섹션
    var recommandSections = RecommandSection.allCases
    
    /// 추천 CollectionView 초기화
    private lazy var recommandCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            self.parentVC?.createBasicListLayout(section: sectionIndex)
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    init(viewModel: DashboardViewModel, parentVC: DashboardViewController?) {
        self.viewModel = viewModel
        self.parentVC = parentVC
        super.init()
        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    private func configure() {
        configureBase()
        configureRecommandCollectionView()
    }
    
    private func configureBase() {
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.isPagingEnabled = true
        self.backgroundColor = .systemBackground
    }
    
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

    // MARK: - Bind
    private func bind() {
        bindUpdateProfile()
        bindRecommandVideoSucceed()
        bindRecommandCommunitySucceed()
        bindLastWorkout()
        bindLastWorkoutGesture()
    }
    
    /// 프로필 업데이트
    private func bindUpdateProfile() {
        AuthManager.shared.isSignIn
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.headerView.setProfileData()
            }
            .store(in: &cancellables)
    }
    
    /// 추천 비디오 로드 완료시 리로드
    private func bindRecommandVideoSucceed() {
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
    private func bindRecommandCommunitySucceed() {
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
    private func bindLastWorkout() {
        viewModel.$lastWorkout
            .receive(on: DispatchQueue.main)
            .sink {[unowned self] data in
                if let data = data {
                    lastWorkoutCell.updateData(data)
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindLastWorkoutGesture() {
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
                
        headerViewLayout(height: 80)
        
        recentRecordViewLayout(height: 100)
        
        challangeViewsLayout(spacing: spacing, height: 220)
        
        recommandCollectionViewLayout(spacing: spacing, height: 600)
    }
    
    private func headerViewLayout(height: CGFloat) {
        contentView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.height.equalTo(height)
        }
    }
    
    private func recentRecordViewLayout(height: CGFloat) {
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
    
    private func challangeViewsLayout(spacing: CGFloat, height: CGFloat) {
        contentView.addSubview(challangeViews)
        
        challangeViews.snp.makeConstraints { make in
            make.top.equalTo(recentRecordView.snp.bottom).offset(8)
            make.height.equalTo(height)
            make.horizontalEdges.equalTo(contentView).inset(20)
        }
    }
    
    private func recommandCollectionViewLayout(spacing: CGFloat,
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
