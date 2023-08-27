//
//  DashboardViewController.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/27/23.
//

import UIKit
import SnapKit
import Combine

final class DashboardViewController: UIViewController {
    
    private let viewModel: HomeRecordsViewModel
    
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var profileImageView: UIImageView = makeProfileImageView()
    private lazy var headerView: UIStackView = makeHeaderView()
    private lazy var recentRecordCell = UIView()
    
    init(viewModel: HomeRecordsViewModel? = nil) {
        self.viewModel = viewModel ?? HomeRecordsViewModel(healthKitManager: HealthKitManager())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayouts()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindSubviews()
    }
    
}

extension DashboardViewController {
    
    private func bindSubviews() {
        // FIXME: View 업데이트시마다 겹치는 증상 수정필요 (그림자 두꺼워지는걸로 확인)
        viewModel.$lastWorkout.sink { data in
            if let data = data {
                self.recentRecordCell = UIView()
                self.recentRecordCell = EventListUICell(data: data, showDate: true)
                self.viewDidLoad()
            }
        }
        .store(in: &subscriptions)
    }
    
    private func setupLayouts() {
        view.addSubview(headerView)
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(56)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(100)
        }
        
        let eventTitle = ViewFactory.label("최근 기록")
            .font(.custom(.sfProLight, size: 15))
            .foregroundColor(.gray)
        view.addSubview(eventTitle)
        
        eventTitle.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view).inset(28)
        }
        
        view.addSubview(recentRecordCell)
        recentRecordCell.snp.makeConstraints { make in
            make.top.equalTo(eventTitle.snp.bottom).offset(8)
            make.leading.trailing.equalTo(view).inset(24)
        }
        
    }
    
    private func setupBindings() {
        
    }
    
    private func makeHeaderView() -> UIStackView {
        let view = UIView()
        
        let title = ViewFactory.label("반가워요, Heon Ha!")
            .font(.custom(.sfProBold, size: 16))
            .foregroundColor(UIColor.secondaryLabel)

        let subtitle = ViewFactory.label("오늘도 화이팅 해볼까요?")
            .font(.custom(.sfProBold, size: 21))
        
        let vstack = ViewFactory.vStack(subviews: [title, subtitle], alignment: .top)
            .setSpacing(8)
        vstack.frame.size = .init(width: view.bounds.width - 48, height: 60)
        
        let hstack = ViewFactory.hStack(subviews: [vstack, profileImageView], alignment: .center)
            .setEdgeInset(.init(top: 0, leading: 24, bottom: 0, trailing: 24))

        return hstack
    }
    
    private func makeProfileImageView() -> UIImageView {
        let profileImage = UIImage(named: "Avatar") ?? UIImage()
        let imageView = UIImageView(image: profileImage)
        imageView.frame.size = .init(width: 56, height: 56)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        return imageView
    }
    
}

#if DEBUG
import SwiftUI

struct DashboardViewController_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview(vc: DashboardViewController())
    }
}
#endif
