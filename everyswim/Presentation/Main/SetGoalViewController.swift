//
//  SetGoalViewController.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/2/23.
//

import UIKit
import SnapKit

final class SetGoalViewController: UIViewController {
    
    private let viewModel = SetGoalViewModel()
    
    // CollectionView
    private lazy var collectionView: UICollectionView = {
        let layout = self.createBasicListLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    private func configure() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SetGoalCell.self, forCellWithReuseIdentifier: SetGoalCell.reuseId)
    }
    
    private func layout() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view)
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide)
            make.centerY.equalTo(view)
        }

    }

    func createBasicListLayout() -> UICollectionViewLayout {
        let section = createSectionLayout()
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func createSectionLayout() -> NSCollectionLayoutSection {
        // Item
        let itemLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        // Group
        let groupLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupLayoutSize,
                                                       subitem: item,
                                                       count: 1)
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        return section
    }
    
}

extension SetGoalViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected!")
    }
    
}

extension SetGoalViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SetGoalCell.reuseId, for: indexPath) as? SetGoalCell else {
            let emptyCell = UICollectionViewCell()
            emptyCell.backgroundColor = .systemPink
            return emptyCell
        }
        
        if indexPath.item == 0 {
            cell.setType(.distance)
        }
        
        if indexPath.item == 1 {
            cell.setType(.lap)
        }
        
        if indexPath.item == 2 {
            cell.setType(.swimCount)
        }
        cell.parent = self
        cell.viewModel = viewModel
        cell.updateCell(viewModel: viewModel)
        
        // TODO: + - 버튼 액션
        
        return cell
    }
    
}

#if DEBUG
import SwiftUI

struct SetGoalViewController_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            SetGoalViewController()
        }
        .ignoresSafeArea()
    }
}
#endif

