//
//  AnimateRingUIView.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/6/23.
//

import UIKit
import SnapKit

final class AnimateRingUIView: UIView {
    
    private let ring: ChallangeRing
    
    private var index: Int
    private var showRing: Bool
    
    private var lineWidth: CGFloat
    private var linePadding: CGFloat
    private var circleSize: CGFloat
    
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
                            radius: circleSize / 2,
                            isAnimate: false)
    }()

    
    private lazy var progressCircle: UIView = {
        return createCircle(progress: ring.progress(),
                            lineWidth: self.lineWidth,
                            lineColor: self.ring.getCircleUIColor(),
                            radius: self.circleSize / 2)
    }()
    
    init(ring: ChallangeRing, index: Int, lineWidth: CGFloat = 12, linePadding: CGFloat = 16, circleSize: CGFloat = 50, showRing: Bool = false) {
        self.ring = ring
        self.index = index
        self.lineWidth = lineWidth
        self.linePadding = linePadding
        self.circleSize = circleSize
        self.showRing = showRing
        super.init(frame: .zero)
        self.configureLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension AnimateRingUIView {
    
    private func configureLayouts() {
        self.addSubview(backgroundView)
        backgroundView.addSubview(backgroundCircle)
        backgroundView.addSubview(progressCircle)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(CGFloat(index) * linePadding)
        }
        
        backgroundCircle.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        progressCircle.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
                                        radius: radius)
        
        let segmentLayer = createLayer(path: segmentPath, lineColor: lineColor, isAnimate: isAnimate)
                
        view.layer.addSublayer(segmentLayer)
        
        return view
    }
    
    private func createLayer(path segmentPath: UIBezierPath, lineColor: UIColor, isAnimate: Bool) -> CAShapeLayer {
        let segmentLayer = CAShapeLayer()
        segmentLayer.path = segmentPath.cgPath
        segmentLayer.lineWidth = lineWidth
        segmentLayer.lineCap = .round
        segmentLayer.strokeColor = lineColor.cgColor
        segmentLayer.fillColor = UIColor.clear.cgColor
        
        if isAnimate {
            addAnimation(to: segmentLayer)
        }
        
        return segmentLayer
    }
    
    private func createSegment(startAngle: CGFloat, 
                               endAngle: CGFloat,
                               radius: CGFloat) -> UIBezierPath {
        let centerPoint = CGPoint(x: radius, y: radius)
        let pathRadius = radius - (radius * 0.1)
        let startAngle = startAngle.toRadians()
        let endAngle = endAngle.toRadians()
        
        return UIBezierPath(arcCenter: centerPoint, 
                            radius: pathRadius,
                            startAngle: startAngle,
                            endAngle: endAngle,
                            clockwise: true)
    }
    
    private func addAnimation(to layer: CALayer) {
        let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.duration = 0.75
        drawAnimation.repeatCount = 1.0
        drawAnimation.isRemovedOnCompletion = false
        drawAnimation.fromValue = 0
        drawAnimation.toValue = 1
        drawAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        layer.add(drawAnimation, forKey: "drawCircleAnimation")
    }

}

#if DEBUG
import SwiftUI

struct AnimateRingUIView_Previews: PreviewProvider {
    
    static let challange = ChallangeRing(type: .distance, count: 50, maxCount: 100)
    
    static var previews: some View {
        UIViewPreview {
            AnimateRingUIView(ring: challange, index: 0, circleSize: 100)
        }
        .frame(width: 100, height: 100)

    }
}
#endif
