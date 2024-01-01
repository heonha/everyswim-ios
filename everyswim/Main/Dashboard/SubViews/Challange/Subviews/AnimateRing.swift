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
        .font(.custom(.sfProBold, size: fontSize))
        .textAlignemnt(.center)
    
    init(data: RingViewModel,
         lineWidth: CGFloat = 4,
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

extension AnimateRing {
    
    func startCircleAnimation() {
        let targetLayer = progressCircle.layer.sublayers!.first!
        removeAnimation(to: targetLayer)
        addAnimation(to: targetLayer, duration: 0.8)
    }
    
    private func layout() {
        self.addSubview(backgroundView)
        backgroundView.addSubview(backgroundCircle)
        backgroundView.addSubview(progressCircle)
        backgroundView.addSubview(text)
        
        backgroundView.snp.makeConstraints { make in
            make.center.equalTo(self)
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
        
        text.snp.makeConstraints { make in
            make.center.equalTo(backgroundView)
            make.height.equalTo(circleSize)
            make.width.equalTo(circleSize / 1.3)
        }
        
    }

    private func createCircle(progress: Double,
                              lineWidth: CGFloat,
                              lineColor: UIColor,
                              radius: CGFloat = 50,
                              isAnimate: Bool = true) -> UIView {
        let view = UIView()
        let segmentPath = createSegment(startAngle: -90,
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
    
    func updateProgressCircle(data: RingViewModel) {
        self.data = data
        self.text.text = data.progressPercentString()
        
        let newSegmentPath = createSegment(startAngle: -90,
                                           endAngle: (data.progress() * 360) - 90,
                                           radius: self.circleSize / 2,
                                           superViewLayer: progressCircle.layer)
        
        if let segmentLayer = self.progressLayer {
            segmentLayer.path = newSegmentPath.cgPath
            segmentLayer.strokeColor = data.getCircleUIColor().cgColor
            
            removeAnimation(to: segmentLayer)
            addAnimation(to: segmentLayer, duration: 0.8)
        }
     }
    
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
    
    private func createSegment(startAngle: CGFloat, 
                               endAngle: CGFloat,
                               radius: CGFloat,
                               superViewLayer: CALayer) -> UIBezierPath {
        
        let centerPoint = CGPoint(x: backgroundView.bounds.midX,
                                  y: backgroundView.bounds.midY)
        let pathRadius = radius - (radius * 0.1)
        let startAngle = startAngle.toRadians()
        let endAngle = endAngle.toRadians()
        
        return UIBezierPath(arcCenter: centerPoint, 
                            radius: pathRadius,
                            startAngle: startAngle,
                            endAngle: endAngle,
                            clockwise: true)
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
