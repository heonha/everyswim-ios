//
//  MessageView.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/24/23.
//

import UIKit

final class MessageView: UILabel {
    
    private var timer: DispatchSourceTimer?

    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.text = "메세지 입니다."
        self.font = .custom(.sfProMedium, size: 16)
        self.textAlignment = .center
        self.textColor = .white
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        self.backgroundColor = .init(hex: "000000", alpha: 0.65)
        self.isHidden = true
        self.numberOfLines = 0
    }
    
    func present(title: String, duration: CGFloat = 2) {
        timer?.cancel()
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)

        self.text = title
        self.alpha = 0
        self.isHidden = false

        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }

        timer?.schedule(deadline: .now() + duration)
        timer?.setEventHandler { [weak self] in
            UIView.animate(withDuration: 0.3) {
                self?.alpha = 0
            } completion: { _ in
                self?.isHidden = true
            }
        }
        timer?.resume() // 타이머 시작
        
    }
    
}
