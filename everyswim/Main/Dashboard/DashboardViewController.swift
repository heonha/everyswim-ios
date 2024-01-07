//
//  DashboardViewController.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/27/23.
//

import UIKit
import SnapKit
import Combine
import SDWebImage

final class DashboardViewController: BaseViewController {

    private let viewModel: DashboardViewModel

    // MARK: - Views
    /// (메인) 스크롤 뷰
    private lazy var scrollView = DashboardScrollView()
    private lazy var contentView = scrollView.contentView
    
    /// 최상단 프로필
    private lazy var headerProfileView = DashboardHeaderView()

    /// 최근 운동 기록 View
    private lazy var lastWorkoutView = LastWorkoutView()
    
    /// 이번주 목표 View
    private var challangeCirclesView = ChallangeCellContainer()
        
    /// 추천 CollectionView
    private lazy var recommandCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            self.createBasicListLayout(section: sectionIndex)
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        return collectionView
    }()
    
    // MARK: - Init & LifeCycles
    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
        layout()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearPublisher.send()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        hideNavigationBar(true)
    }
    
}

// MARK: - Configure
extension DashboardViewController {
    
    private func configure() {
        configureRecommandCollectionView()
    }
    
    /// [Config] CollectionView
    private func configureRecommandCollectionView() {
        recommandCollectionView.dataSource = self
        recommandCollectionView.delegate = self
        
        recommandCollectionView.register(RecommandCollectionViewHeader.self,
                                         forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                         withReuseIdentifier: RecommandCollectionViewHeader.reuseId)
        recommandCollectionView.register(RecommandVideoReusableCell.self,
                                         forCellWithReuseIdentifier: RecommandVideoReusableCell.reuseId)
        recommandCollectionView.register(CommunityReusableCell.self,
                                         forCellWithReuseIdentifier: CommunityReusableCell.reuseId)
        recommandCollectionView.register(EmptyCollectionViewCell.self,
                                         forCellWithReuseIdentifier: EmptyCollectionViewCell.reuseID)
        
    }
    
}

// MARK: - Layout
extension DashboardViewController {
    private func layout() {
        scrollViewLayout()
        let spacing: CGFloat = 28
        layoutHeaderView(height: 80)
        layoutRecentRecordView(height: 100)
        layoutChallangeViews(spacing: spacing, height: 220)
        layoutRecommandCollectionView(spacing: spacing, height: 600)
    }
    
    private func scrollViewLayout() {
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    /// [Layout] HeaderView
    private func layoutHeaderView(height: CGFloat) {
        contentView.addSubview(headerProfileView)
        headerProfileView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.height.equalTo(height)
        }
    }
    
    /// [Layout] RecentRecordView
    private func layoutRecentRecordView(height: CGFloat) {
        contentView.addSubview(lastWorkoutView)
        
        lastWorkoutView.snp.makeConstraints { make in
            make.top.equalTo(headerProfileView.snp.bottom).offset(4)
            make.height.equalTo(height)
            make.horizontalEdges.equalTo(contentView).inset(20)
        }
        
    }
    
    /// [Layout] ChallangeView
    private func layoutChallangeViews(spacing: CGFloat, height: CGFloat) {
        contentView.addSubview(challangeCirclesView)
        
        challangeCirclesView.snp.makeConstraints { make in
            make.top.equalTo(lastWorkoutView.snp.bottom).offset(8)
            make.height.equalTo(height)
            make.horizontalEdges.equalTo(contentView).inset(20)
        }
    }
    
    /// [Layout] RecommandCollectionView
    private func layoutRecommandCollectionView(spacing: CGFloat,
                                               height: CGFloat) {
        contentView.addSubview(recommandCollectionView)
        recommandCollectionView.snp.makeConstraints { make in
            make.top.equalTo(challangeCirclesView.snp.bottom).offset(spacing)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.height.equalTo(height)
            make.bottom.equalTo(contentView)
        }
        
    }
}

// MARK: - Bind
extension DashboardViewController {
    
    private func bind() {
        // MARK: Inputs
        let input = DashboardViewModel
            .Input(viewWillAppearPublisher: viewWillAppearPublisher.eraseToAnyPublisher(),
                   lastWorkoutCellTapped: lastWorkoutView.lastWorkoutCell.tapPublisher())
        
        // MARK: Outputs
        let output = viewModel.transform(input: input)
        
        /// 추천 비디오/커뮤니티 로드 완료시 리로드
        output.updateCollectionViewPublisher
            .sink { [weak self] _ in
                self?.recommandCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        /// 프로필 업데이트
        output.updateProfileViewPublisher
            .sink { [weak self] profile in
                print("Profile을 셋업합니다.")
                self?.headerProfileView.updateProfileData(profile: profile)
            }
            .store(in: &cancellables)
        
        /// 최근 운동기록 데이터 업데이트
        output.updateLastWorkoutPublisher
            .sink { [weak self] data in
                self?.lastWorkoutView.updateData(data)
            }
            .store(in: &cancellables)
        
        /// 최근 운동 DetailViewController Push
        output.pushWorkoutDetailViewPublisher
            .sink { [weak self] data in
                let detailVC = ActivityDetailViewController(data: data)
                self?.push(detailVC, animated: true)
            }
            .store(in: &cancellables)
        
        /// 목표 Circle 애니메이션 재생.
        output.updateChallangeCircleAnimationPublisher
            .sink { [weak self] _ in
                self?.challangeCirclesView.startCircleAnimation()
            }
            .store(in: &cancellables)
        
        output.updateRings
            .sink { [weak self] _ in
                self?.challangeCirclesView.updateRings()
            }
            .store(in: &cancellables)
        
    }
    
}

// MARK: - Recommand CollectionView Configurations
extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    /// `레이아웃` 생성
    public func createBasicListLayout(section: Int) -> NSCollectionLayoutSection {
        switch section {
        case 0:
            return createSectionLayout(height: 170)
        case 1:
            return createCommunitySectionLayout(height: 200)
        default:
            return createSectionLayout(height: 0)
        }
    }

    /// `추천 영상 레이아웃` 섹션 생성
    private func createSectionLayout(height: CGFloat) -> NSCollectionLayoutSection {
        
        // Item
        let itemWidth = NSCollectionLayoutDimension.fractionalWidth(1.0)
        let itemHeight = NSCollectionLayoutDimension.fractionalWidth(0.56)

        let itemLayoutSize = NSCollectionLayoutSize(widthDimension: itemWidth,
                                                    heightDimension: itemHeight)
        let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 20, bottom: 2, trailing: 10)
        
        // Group
        // FIXME: 16.0+ 에서 vertical (layoutSize:, subitem:, count:) deprecated됨
        let groupWidth: NSCollectionLayoutDimension = .fractionalWidth(0.9)
        let groupHeight: NSCollectionLayoutDimension = .absolute(height)

        let groupLayoutSize = NSCollectionLayoutSize(widthDimension: groupWidth,
                                                     heightDimension: groupHeight)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupLayoutSize,
                                                       subitem: item,
                                                       count: 1)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = createSectionHeader()
        section.contentInsets = .init(top: 8, leading: 0, bottom: 44, trailing: 0)
        return section
    }
    
    /// `추천 커뮤니티 레이아웃` 섹션 생성
    private func createCommunitySectionLayout(height: CGFloat) -> NSCollectionLayoutSection {
        
        // Item
        let itemLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .fractionalWidth(0.56))
        let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 20, bottom: 2, trailing: 20)
        
        // Group
        // FIXME: 16.0+ 에서 vertical (layoutSize:, subitem:, count:) deprecated됨
        let groupLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .absolute(height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupLayoutSize,
                                                       subitem: item,
                                                       count: 1)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = createSectionHeader()
        section.contentInsets = .init(top: 8, leading: 0, bottom: 44, trailing: 0)
        return section
    }
    
    /// 섹션 `헤더` 생성
    private func createSectionHeader() -> [NSCollectionLayoutBoundarySupplementaryItem] {
        typealias SupplementaryHeader = NSCollectionLayoutBoundarySupplementaryItem
        
        let width: NSCollectionLayoutDimension = .fractionalWidth(1.0)
        let height: NSCollectionLayoutDimension = .estimated(44)
        
        let headers = [
            SupplementaryHeader(layoutSize: NSCollectionLayoutSize(widthDimension: width,
                                                                   heightDimension: height),
                                elementKind: UICollectionView.elementKindSectionHeader,
                                alignment: .top)
        ]
        return headers
    }
    
    /// 섹션 `헤더 View 구성`
    func collectionView(_ collectionView: UICollectionView, 
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        
        guard let header = collectionView
            .dequeueReusableSupplementaryView(ofKind: kind, 
                                              withReuseIdentifier: RecommandCollectionViewHeader.reuseId,
                                              for: indexPath) as? RecommandCollectionViewHeader else {return UICollectionReusableView() }
        
        let section = viewModel.recommandSections[indexPath.section]
        header.configure(title: section.title, subtitle: section.subtitle)
        
        return header
    }

    /// `섹션별 아이템 수` 정의
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch viewModel.recommandSections[section] {
        case .video:
            guard !viewModel.recommandVideos.value.isEmpty else {return 1}
            return viewModel.recommandVideos.value.count
        case .community:
            guard !viewModel.recommandCommunities.value.isEmpty else {return 1}
            return viewModel.recommandCommunities.value.count
        }
    }
    
    /// `섹션 수` 정의
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.recommandSections.count
    }
    
    /// `Cell` 구성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("Cell Reloaded")
        switch viewModel.recommandSections[indexPath.section] {
        // 추천영상
        case .video:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommandVideoReusableCell.reuseId,
                                                                for: indexPath) as? RecommandVideoReusableCell else {
                return UICollectionViewCell()
            }
            
            if viewModel.recommandVideos.value.isEmpty {
                let dummyData = VideoCollectionData(id: "-", type: "", url: "", imageUrl: "")
                cell.setData(data: dummyData)
                return cell
            }

            let cellViewModel = viewModel.recommandVideos.value[indexPath.item]
            cell.setData(data: cellViewModel)
            
            return cell
        
        // 수영 커뮤니티
        case .community:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommunityReusableCell.reuseId, for: indexPath) as? CommunityReusableCell else { return UICollectionViewCell() }
            
            if viewModel.recommandCommunities.value.isEmpty {
                let dummyData = CommunityCollectionData(description: "", url: "", imageUrl: "")
                cell.configure(viewModel: dummyData)
                return cell
            }
            
            let cellViewModel = viewModel.recommandCommunities.value[indexPath.item]
            cell.configure(viewModel: cellViewModel)
            return cell
        }

    }
    
    // Cell 선택 가능여부
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }

}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct DashboardViewController_Previews: PreviewProvider {
    
    static let viewController = DashboardViewController(viewModel: viewModel)
    static let viewModel = DashboardViewModel()
    
    static var previews: some View {
        UIViewControllerPreview {
            viewController
        }
        .ignoresSafeArea()
    }
}
#endif
