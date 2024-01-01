//
//  AnimateRingUIView.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/6/23.
//

import UIKit
import SnapKit

final class AnimateRing: UIView {
    
    private var data: RingViewModel
    
    private var showRing: Bool
    private var lineWidth: CGFloat
    private var linePadding: CGFloat
    private var circleSize: CGFloat
    private var fontSize: CGFloat
    
    //
    private var progressLayer: CAShapeLayer?
    
    private lazy var backgroundView = {
        let zstack = UIView()
        zstack.backgroundColor = .clear
        zstack.frame = .init(x: 0, y: 0, width: self.circleSize, height: self.circleSize)
        return zstack
    }()
    
    private lazy var backgroundCircle: UIView = {
        return createCircle(progress: 1,
                            lineWidth: lineWidth,
                            lineColor: UIColor.gray.withAlphaComponent(0.16),
                            radius: self.circleSize / 2,
                            isAnimate: false)
    }()
    
    private lazy var progressCircle: UIView = {
        return createCircle(progress: data.progress(),
                            lineWidth: self.lineWidth,
                            lineColor: self.data.getCircleUIColor(),
                            radius: self.circleSize / 2)
    }()
    
    private lazy var text = ViewFactory
        .label(data.progressPercentString())
        .adjustsFontSizeToFitWidth()
        .font(.custom(.sfProBold, size: fontSize))
        .textAlignemnt(.center)
    
    init(data: RingViewModel,
         lineWidth: CGFloat = 5,
         linePadding: CGFloat = 16,
         circleSize: CGFloat = 40,
         textSize: CGFloat = 12,
         showRing: Bool = false) {
        
        self.data = data
        self.lineWidth = lineWidth
        self.linePadding = linePadding
        self.circleSize = circleSize
        self.showRing = showRing
        self.fontSize = textSize
        super.init(frame: .zero)
        
        self.layout()
        self.startCircleAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Configure Circle
extension AnimateRing {
    
    /// Progress 데이터를 업데이트 하고 Circle레이어 및 textLabel을 다시 그립니다.
    func updateProgressCircle(data: RingViewModel) {
        self.data = data
        self.text.text = data.progressPercentString()
        
        let newCircleSegmentPath = createBezierPath(startAngle: -90,
                                                    endAngle: (data.progress() * 360) - 90,
                                                    radius: self.circleSize / 2,
                                                    superViewLayer: progressCircle.layer)
        
        if let circleSegmentLayer = self.progressLayer {
            circleSegmentLayer.path = newCircleSegmentPath.cgPath
            circleSegmentLayer.strokeColor = data.getCircleUIColor().cgColor
            
            removeAnimation(to: circleSegmentLayer)
            addAnimation(to: circleSegmentLayer, duration: 0.8)
        }
    }
    
    /// `원 레이어를 라인 레이어로 마스킹`
    /// 마스킹하여 새 view hirachy를 생성하여 리턴한다.
    private func createCircle(progress: Double,
                              lineWidth: CGFloat,
                              lineColor: UIColor,
                              radius: CGFloat = 50,
                              isAnimate: Bool = true) -> UIView {
        let view = UIView()
        let segmentPath = createBezierPath(startAngle: -90,
                                        endAngle: (progress * 360) - 90,
                                        radius: radius,
                                        superViewLayer: view.layer)
        
        let segmentLayer = createLayer(path: segmentPath,
                                       lineColor: lineColor,
                                       isAnimate: isAnimate)
        
        view.layer.addSublayer(segmentLayer)
        self.progressLayer = segmentLayer
        
        return view
    }
    
    /// `라인 마스크 레이어`를 생성한다.
    /// 컴퍼스 그리듯이 원형으로 시작과 끝을 결정. (startAngle, endAngle로)
    private func createLayer(path segmentPath: UIBezierPath,
                             lineColor: UIColor,
                             isAnimate: Bool) -> CAShapeLayer {
        let segmentLayer = CAShapeLayer()
        segmentLayer.path = segmentPath.cgPath
        segmentLayer.lineWidth = lineWidth
        segmentLayer.lineCap = .round
        segmentLayer.strokeColor = lineColor.cgColor
        segmentLayer.fillColor = UIColor.clear.cgColor

        return segmentLayer
    }
    
    /// `원의 시작과 끝부분의 각도`레이어를 생성.
    /// 컴퍼스 그리듯이 원형으로 시작과 끝을 결정. (startAngle, endAngle로)
    private func createBezierPath(startAngle: CGFloat,
                                  endAngle: CGFloat,
                                  radius: CGFloat,
                                  superViewLayer: CALayer) -> UIBezierPath {
        
        let centerPoint = CGPoint(x: backgroundView.bounds.midX,
                                  y: backgroundView.bounds.midY)
        let pathRadius = radius - (radius * 0.1)
        let startAngle = startAngle.toRadians()
        let endAngle = endAngle.toRadians()
        
        /// `UIBezierPath`: 사용자 정의 보기에서 렌더링할 수 있는 직선 및 곡선 세그먼트로 구성된 경로입니다.
        return UIBezierPath(arcCenter: centerPoint,
                            radius: pathRadius,
                            startAngle: startAngle,
                            endAngle: endAngle,
                            clockwise: true)
    }
    
    // MARK: - Animation Methods
    func startCircleAnimation() {
        let targetLayer = progressCircle.layer.sublayers!.first!
        removeAnimation(to: targetLayer)
        addAnimation(to: targetLayer, duration: 0.8)
    }
    
    private func addAnimation(to layer: CALayer, duration: CGFloat = 1) {
        let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.duration = duration
        drawAnimation.repeatCount = 1
        drawAnimation.fromValue = 0
        drawAnimation.toValue = 1
        drawAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        drawAnimation.isRemovedOnCompletion = false
        layer.add(drawAnimation, forKey: "drawCircleAnimation")
    }
    
    private func removeAnimation(to layer: CALayer) {
        layer.removeAnimation(forKey: "drawCircleAnimation")
    }

}

// MARK: - Layouts
extension AnimateRing {
    
    private func layout() {
        self.addSubview(backgroundView)
        backgroundView.addSubview(backgroundCircle)
        backgroundView.addSubview(progressCircle)
        backgroundView.addSubview(text)
        
        backgroundView.snp.makeConstraints { make in
            make.size.equalTo(circleSize)
        }
        
        backgroundCircle.snp.makeConstraints { make in
            make.center.equalTo(backgroundCircle)
            make.size.equalTo(circleSize)
        }
        
        progressCircle.snp.makeConstraints { make in
            make.center.equalTo(backgroundCircle)
            make.size.equalTo(circleSize)
        }
        
        let textWidth = circleSize / 1.3
        text.snp.makeConstraints { make in
            make.center.equalTo(backgroundView)
            make.height.lessThanOrEqualTo(circleSize)
            make.width.lessThanOrEqualTo(textWidth)
        }
        
    }
    
}

#if DEBUG
import SwiftUI

struct AnimateRingUIView_Previews: PreviewProvider {
    
    static let view = AnimateRing(data: challange, circleSize: 50)
    static let challange = RingViewModel(type: .distance, count: 30, maxCount: 100)
    static let updatedChallange = RingViewModel(type: .distance, count: 80, maxCount: 100)

    static var previews: some View {
        UIViewPreview {
            view
        }
        .frame(width: 100, height: 100)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                view.updateProgressCircle(data: updatedChallange)
            }
        }

    }
}
#endif
