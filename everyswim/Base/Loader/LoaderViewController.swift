//
//  LoaderViewController.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/30/23.
//
// https://medium.com/@2018.itsuki/custom-activity-indicator-in-swift-ios-7aa3521f6a36

import UIKit
import SnapKit

final class LoaderViewController: BaseViewController {
    
    private var loaderContainerView = UIView()
    private var loaderImage = UIImageView()

    init() {
        super.init()
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAnimation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    private func configure() {
        
        loaderContainerView.layer.borderWidth = 1.0
        loaderContainerView.layer.borderColor = UIColor.clear.cgColor
        loaderContainerView.layer.cornerRadius = 4.0
        loaderContainerView.clipsToBounds = true

    }
    
    private func layout() {
        
    }
    
    private func bind() {
 
    }
    
    private func startAnimation() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = 2 * Double.pi
        rotation.duration = 1.0
        rotation.repeatCount = .infinity
        loaderImage.layer.add(rotation, forKey: "spin")
    }

    private func stopAnimation() {
        loaderImage.layer.removeAllAnimations()
    }
    
}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct LoaderViewController_Previews: PreviewProvider {
    
    static let viewController = LoaderViewController()
    
    static var previews: some View {
        UIViewControllerPreview {
            viewController
        }
        .ignoresSafeArea()
    }
}
#endif
