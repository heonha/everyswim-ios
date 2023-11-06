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
    
    /// 하단 이미지 슬라이더
    private let imageSlider = ImageSliderView()
    
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
        slideTimer()
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
        configureImageSlider()
        configurePageController()
    }
    
    private func configureImageSlider() {
        imageSlider.dataSource = self
        imageSlider.delegate = self
        imageSlider.register(ImageSliderCell.self,
                             forCellWithReuseIdentifier: "ImageSliderCell")
    }
    
    private func configurePageController() {
        pageController.currentPage = 0
        pageController.numberOfPages = viewModel.slideData.count

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
        contentView.addSubview(pageController)

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
        
        contentView.addSubview(imageSlider)

        imageSlider.snp.makeConstraints { make in
            make.top.equalTo(challangeViews.snp.bottom).offset(spacing)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.height.equalTo(200)
        }
        
        pageController.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(imageSlider).inset(20)
            make.bottom.equalTo(imageSlider).inset(20)
            make.height.equalTo(40)
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
            .store(in: &cancellables)
    }
    
}

// MARK: SliderView Delegate, DataSource
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
