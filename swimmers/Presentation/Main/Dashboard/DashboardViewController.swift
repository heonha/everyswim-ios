//
//  DashboardViewController.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/27/23.
//

import UIKit
import SnapKit
import Combine

final class DashboardViewController: UIViewController, CombineCancellable {
    
    var cancellables: Set<AnyCancellable> = .init()
    
    private let viewModel: DashboardViewModel
    
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var headerView = DashboardHeaderView(viewModel: viewModel)
    
    private lazy var recentRecordView: UIStackView = {
        let vstack = ViewFactory
            .vStack(subviews: [eventTitle, lastWorkoutView])
        
        lastWorkoutView.snp.makeConstraints { make in
            make.height.equalTo(70)
        }
        return vstack
    }()
    
    private let imageSlider = ImageSliderView()
    var counter = 0
    private let pageController = UIPageControl(frame: .zero)
    
    private lazy var lastWorkoutView = RecordSmallCell(data: viewModel.lastWorkout
                                                           ?? TestObjects.swimmingData.first!, showDate: true)
    
    private let eventTitle = ViewFactory
        .label("  최근 기록")
        .font(.custom(.sfProLight, size: 15))
        .foregroundColor(.gray)
    
    private var challangeViews = ChallangeCellContainer()
    
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
        bindSubviews()
        slideTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        updateChallangeView()
    }
    
}

extension DashboardViewController {
    
    private func bindSubviews() {
        viewModel.$lastWorkout
            .receive(on: RunLoop.main)
            .sink {[unowned self] data in
                if let data = data {
                    lastWorkoutView.updateData(data)
                }
            }
        .store(in: &subscriptions)
        
        lastWorkoutView.gesturePublisher(.tap())
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let data = self?.viewModel.lastWorkout else { return }
                
                let detailVC = RecordDetailViewController(data: data)
                self?.push(detailVC, animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func configure() {
        imageSlider.dataSource = self
        imageSlider.delegate = self
        imageSlider.register(ImageSliderCell.self,
                             forCellWithReuseIdentifier: "ImageSliderCell")

        pageController.currentPage = 0
        pageController.numberOfPages = viewModel.slideData.count
    }
    
    // MARK: - Layout
    private func layout() {
        view.addSubview(headerView)
        view.addSubview(recentRecordView)
        view.addSubview(imageSlider)
        view.addSubview(pageController)
        view.addSubview(challangeViews)
        
        let spacing = 40

        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
        }
        
        recentRecordView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(spacing)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        imageSlider.snp.makeConstraints { make in
            make.top.equalTo(recentRecordView.snp.bottom).offset(spacing)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        pageController.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(imageSlider).inset(20)
            make.bottom.equalTo(imageSlider).inset(20)
            make.height.equalTo(40)
        }
        
        challangeViews.snp.makeConstraints { make in
            make.top.equalTo(imageSlider.snp.bottom).offset(spacing)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
    }
    
    private func updateChallangeView() {
        challangeViews.startCircleAnimation()
    }
    
    private func slideTimer() {
        Timer
            .publish(every: 3, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if counter < self.viewModel.slideData.count {
                    let index = IndexPath(item: counter, section: 0)
                    self.imageSlider.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
                    self.pageController.currentPage = counter
                    counter += 1
                } else {
                    counter = 0
                    let index = IndexPath(item: counter, section: 0)
                    self.imageSlider.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
                    self.pageController.currentPage = counter
                }
            }
            .store(in: &subscriptions)
    }
    
}

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.slideData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageSliderCell", for: indexPath) as? ImageSliderCell else { return UICollectionViewCell() }
        let data = viewModel.slideData[indexPath.row]
        cell.imageView.image = UIImage(named: data.imageName)
        cell.titleLabel.text = data.title
        cell.subtitleLabel.text = data.subtitle
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }

}

extension DashboardViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                      height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
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
