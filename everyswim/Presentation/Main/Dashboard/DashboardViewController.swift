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
    
    /// 최근 운동 기록 Views - `title`
    private let eventTitle = ViewFactory
        .label("최근 기록")
        .font(.custom(.sfProLight, size: 15))
        .foregroundColor(.gray)
    
    /// 최근 운동 기록 Views - `cell`
    private lazy var lastWorkoutCell = RecordSmallCell(data: viewModel.lastWorkout ?? TestObjects.swimmingData.first!,
                                                       showDate: true)
    
    /// `목표 현황` View
    private var challangeViews = ChallangeCellContainer()
    
    /// 미디어 슬라이더
    private var sections = RecommandSection.allCases
    private lazy var mediaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createBasicListLayout())
    
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
        layout()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        hideNavigationBar(false)
        updateChallangeView()
    }
    
}

extension DashboardViewController {
    
    private func bind() {
        bindLastWorkout()
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
                
                let detailVC = RecordDetailViewController(data: data)
                self?.push(detailVC, animated: true)
            }
            .store(in: &cancellables)
    }
    
    
    // MARK: Configures
    private func configure() {
        configureMediaSlider()
    }
    
    private func configureMediaSlider() {

        mediaCollectionView.register(RecommandCollectionViewHeader.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: RecommandCollectionViewHeader.reuseId)
        
        mediaCollectionView.dataSource = self
        mediaCollectionView.delegate = self
        mediaCollectionView.register(RecommandCollectionCell.self,
                               forCellWithReuseIdentifier: RecommandCollectionCell.reuseId)
        
        mediaCollectionView.backgroundColor = .white
        mediaCollectionView.showsVerticalScrollIndicator = false
        mediaCollectionView.showsHorizontalScrollIndicator = false
        mediaCollectionView.isPagingEnabled = true
        
    }
    
    // MARK: Layout
    private func layout() {
        
        
        let contentView = scrollView.contentView
        let spacing: CGFloat = 28
        
        scrollViewLayout()
        
        headerViewLayout(contentView: contentView)
        
        recentRecordViewLayout(contentView: contentView, spacing: spacing)
        
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
    
    private func recentRecordViewLayout(contentView: UIView, spacing: CGFloat) {
        contentView.addSubview(recentRecordView)

        recentRecordView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(spacing)
            make.horizontalEdges.equalTo(contentView).inset(10)
        }
        
        lastWorkoutCell.snp.makeConstraints { make in
            make.height.equalTo(70)
        }
    }
    
    private func challangeViewsLayout(contentView: UIView, spacing: CGFloat) {
        contentView.addSubview(challangeViews)
        
        challangeViews.snp.makeConstraints { make in
            make.top.equalTo(recentRecordView.snp.bottom).offset(spacing)
            make.leading.equalTo(contentView).offset(20)
            make.trailing.equalTo(contentView).offset(-20)
            make.height.equalTo(200)
        }
    }
    
    private func imageSliderViewsLayout(contentView: UIView, spacing: CGFloat) {
        
        contentView.addSubview(mediaCollectionView)
        contentView.addSubview(pageController)

        mediaCollectionView.isScrollEnabled = false
        
        mediaCollectionView.snp.makeConstraints { make in
            make.top.equalTo(challangeViews.snp.bottom).offset(spacing)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.height.equalTo(500)
        }

    }
    
    private func updateChallangeView() {
        challangeViews.startCircleAnimation()
    }
    
}

// MARK: - SliderView Delegate, DataSource
extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    /// `레이아웃` 생성
    func createBasicListLayout() -> UICollectionViewLayout {
        let section = createSectionLayout()
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    /// `레이아웃` 섹션 생성
    private func createSectionLayout() -> NSCollectionLayoutSection {
        
        // Item
        let itemLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalWidth(0.45))
        let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 20, bottom: 2, trailing: 20)
        
        // Group
        // FIXME: 16.0+ 에서 vertical (layoutSize:, subitem:, count:) deprecated됨
        let groupLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupLayoutSize,
                                                       subitem: item,
                                                       count:1)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = createSectionHeader()
        return section
    }
    
    /// 섹션 `헤더` 생성
    private func createSectionHeader() -> [NSCollectionLayoutBoundarySupplementaryItem] {
        typealias SupplementaryHeader = NSCollectionLayoutBoundarySupplementaryItem
        
        let headers = [
            SupplementaryHeader(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                   heightDimension: .absolute(50)),
                                elementKind: UICollectionView.elementKindSectionHeader,
                                alignment: .top)
        ]
        return headers
    }
    
        
    /// 섹션 `헤더 View 구성`
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RecommandCollectionViewHeader.reuseId, for: indexPath) as? RecommandCollectionViewHeader else {return UICollectionReusableView() }
        
        let section = sections[0]
        let titleString = section.title
        header.configure(with: titleString)
        
        return header
    }

    /// `섹션별 아이템 수` 정의
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.recommandVideos.count
    }
    
    /// `Cell` 구성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommandCollectionCell.reuseId, for: indexPath) as? RecommandCollectionCell else { return UICollectionViewCell() }
        let data = viewModel.recommandVideos[indexPath.row]
        cell.imageView.sd_setImage(with: URL(string: data.imageUrl)!)
        cell.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { _ in
                let url = URL.init(string: data.mediaUrl)!
                UIApplication.shared.open(url)
            }
            .store(in: &cancellables)
        
        return cell
    }
    
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
