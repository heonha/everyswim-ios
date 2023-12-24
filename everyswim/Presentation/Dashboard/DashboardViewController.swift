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

protocol ObservableMessage {
    associatedtype ViewModelType: BaseViewModel
    var cancellables: Set<AnyCancellable> {get set}
    var viewModel: ViewModelType { get set }
    func observeMessage()
    func presentMessage(title: String)
}

final class DashboardViewController: BaseViewController, ObservableMessage {
    
    var viewModel: DashboardViewModel
            
    private lazy var mainView = DashboardView(viewModel: viewModel, parentVC: self)

    // MARK: - Init & LifeCycles
    init(viewModel: DashboardViewModel? = nil) {
        self.viewModel = viewModel ?? DashboardViewModel(healthKitManager: HealthKitManager())
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
        observe()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.needsProfileUpdate() {
            mainView.headerView.setProfileData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        hideNavigationBar(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.cancellables = .init()
    }
    
}

extension DashboardViewController {
    
    // MARK: - Bind
    func observe() {
        observeMessage()
    }
    
    func observeMessage() {
        viewModel.isPresentMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isPresent in
                guard let self = self else { return }
                if isPresent {
                    self.presentMessage(title: viewModel.presentMessage.value)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Configures
    private func configure() {
    }
    
    // MARK: - Layout
    private func layout() {
        scrollViewLayout()
    }
    
    private func scrollViewLayout() {
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
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
        
        let section = mainView.recommandSections[indexPath.section]
        header.configure(title: section.title, subtitle: section.subtitle)
        
        return header
    }

    /// `섹션별 아이템 수` 정의
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch mainView.recommandSections[section] {
        case .video:
            return viewModel.recommandVideos.count
        case .community:
            return viewModel.recommandCommunities.count
        }
    }
    
    /// `섹션 수` 정의
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return mainView.recommandSections.count
    }
    
    /// `Cell` 구성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch mainView.recommandSections[indexPath.section] {
        // 추천영상
        case .video:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommandVideoReusableCell.reuseId, 
                                                                for: indexPath) as? RecommandVideoReusableCell else {
                return UICollectionViewCell()
            }

            let cellViewModel = viewModel.recommandVideos[indexPath.item]
            cell.setData(data: cellViewModel)
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
