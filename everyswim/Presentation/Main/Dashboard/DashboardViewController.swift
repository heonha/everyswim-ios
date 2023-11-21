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

final class DashboardViewController: UIViewController, CombineCancellable {
    
    var cancellables: Set<AnyCancellable> = .init()
    
    private let viewModel: DashboardViewModel
    
    // MARK: Properties
    private var counter = 0
    private let pageController = UIPageControl(frame: .zero)
    
    // MARK: Views
    private let scrollView = BaseScrollView()
    
    /// `상단 헤더 뷰` (프로필)
    private lazy var headerView = DashboardHeaderView(viewModel: viewModel)
    
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
    
    
    // MARK: Recommand Collection View
    /// 섹션
    private var sections = RecommandSection.allCases
    
    /// 추천 CollectionView 초기화
    private lazy var recommandCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            self.createBasicListLayout(section: sectionIndex)
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    // MARK: - Init & LifeCycles
    init(viewModel: DashboardViewModel? = nil) {
        self.viewModel = viewModel ?? DashboardViewModel(healthKitManager: HealthKitManager())
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
        bind()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        hideNavigationBar(true)
        updateChallangeView()
    }
    
}

extension DashboardViewController {
    
    private func bind() {
        bindUpdateProfile()
        bindRecommandVideoSucceed()
        bindRecommandCommunitySucceed()
        bindLastWorkout()
    }
    
    private func bindUpdateProfile() {
        AuthManager.shared.$isSignIn
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.headerView.setProfileData()
            }
            .store(in: &cancellables)
    }
    
    private func bindRecommandVideoSucceed() {
        viewModel.$recommandVideoSuccessed.receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                if value {
                    self?.recommandCollectionView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindRecommandCommunitySucceed() {
        viewModel.$recommandCommunitySuccessed.receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                if value {
                    self?.recommandCollectionView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindLastWorkout() {
        // 최근 운동기록 데이터 업데이트
        viewModel.$lastWorkout
            .receive(on: DispatchQueue.main)
            .sink {[unowned self] data in
                if let data = data {
                    lastWorkoutCell.updateData(data)
                }
            }
        .store(in: &cancellables)
        
        // 최근 운동기록 제스쳐
        lastWorkoutCell.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let data = self?.viewModel.lastWorkout else { return }
                
                let detailVC = ActivityDetailViewController(data: data)
                self?.push(detailVC, animated: true)
            }
            .store(in: &cancellables)
    }
    
    
    // MARK: Configures
    private func configure() {
        configureMediaSlider()
    }
    
    private func configureMediaSlider() {

        recommandCollectionView.register(RecommandCollectionViewHeader.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: RecommandCollectionViewHeader.reuseId)
        
        recommandCollectionView.dataSource = self
        recommandCollectionView.delegate = self
        recommandCollectionView.register(RecommandVideoReusableCell.self,
                               forCellWithReuseIdentifier: RecommandVideoReusableCell.reuseId)
        recommandCollectionView.register(CommunityReusableCell.self,
                               forCellWithReuseIdentifier: CommunityReusableCell.reuseId)

        recommandCollectionView.backgroundColor = .white
        recommandCollectionView.showsVerticalScrollIndicator = false
        recommandCollectionView.showsHorizontalScrollIndicator = false
        recommandCollectionView.isPagingEnabled = true
        
    }
    
    // MARK: Layout
    private func layout() {
        let contentView = scrollView.contentView
        let spacing: CGFloat = 28
        
        scrollViewLayout()
        
        headerViewLayout(contentView: contentView)
        
        recentRecordViewLayout(contentView: contentView)
        
        challangeViewsLayout(contentView: contentView, spacing: spacing)
        
        imageSliderViewsLayout(contentView: contentView, spacing: spacing)
    }
    

    private func scrollViewLayout() {
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
    }
    
    private func headerViewLayout(contentView: UIView) {
        contentView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
        }
    }
    
    private func recentRecordViewLayout(contentView: UIView) {
        contentView.addSubview(recentRecordView)
        
        recentRecordView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(4)
            make.height.equalTo(100)
            make.horizontalEdges.equalTo(contentView).inset(20)
        }
        
        eventTitle.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(recentRecordView)
        }
        
        
        lastWorkoutCell.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(recentRecordView)
        }
        
    }
    
    
    private func challangeViewsLayout(contentView: UIView, spacing: CGFloat) {
        contentView.addSubview(challangeViews)
        
        challangeViews.snp.makeConstraints { make in
            make.top.equalTo(recentRecordView.snp.bottom).offset(8)
            make.height.equalTo(220)
            make.horizontalEdges.equalTo(contentView).inset(20)
        }
    }
    
    private func imageSliderViewsLayout(contentView: UIView, spacing: CGFloat) {
        
        contentView.addSubview(recommandCollectionView)
        contentView.addSubview(pageController)

        recommandCollectionView.isScrollEnabled = false
        recommandCollectionView.snp.makeConstraints { make in
            make.top.equalTo(challangeViews.snp.bottom).offset(spacing)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.height.equalTo(600)
            make.bottom.equalTo(contentView)
        }

    }
    
    private func updateChallangeView() {
        challangeViews.startCircleAnimation()
    }
    
}

// MARK: - Recommand CollectionView Configurations

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    /// `레이아웃` 생성
    func createBasicListLayout(section: Int) -> NSCollectionLayoutSection {
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
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 20, bottom: 2, trailing: 20)
        
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
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RecommandCollectionViewHeader.reuseId, for: indexPath) as? RecommandCollectionViewHeader else {return UICollectionReusableView() }
        
        let section = sections[indexPath.section]
        header.configure(title: section.title, subtitle: section.subtitle)
        
        return header
    }

    /// `섹션별 아이템 수` 정의
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch sections[section] {
        case .video:
            return viewModel.recommandVideos.count
        case .community:
            return viewModel.recommandCommunities.count
        }
    }
    
    /// `섹션 수` 정의
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    /// `Cell` 구성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch sections[indexPath.section] {
        // 추천영상
        case .video:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommandVideoReusableCell.reuseId, for: indexPath) as? RecommandVideoReusableCell else { return UICollectionViewCell() }

            let cellViewModel = viewModel.recommandVideos[indexPath.item]
            cell.configure(viewModel: cellViewModel)
            return cell
        
        // 수영 커뮤니티
        case .community:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommunityReusableCell.reuseId, for: indexPath) as? CommunityReusableCell else { return UICollectionViewCell() }
            
            let cellViewModel = viewModel.recommandCommunities[indexPath.item]
            cell.configure(viewModel: cellViewModel)
            return cell
        }

    }
    
    // Cell 선택 가능여부
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }

}

#if DEBUG
import SwiftUI

struct DashboardViewController_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            DashboardViewController()
        }
        .ignoresSafeArea()
    }
}
#endif
