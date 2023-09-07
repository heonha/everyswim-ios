//
//  AnimateRingUIView.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/6/23.
//

import UIKit
import SnapKit

final class AnimateRingUIView: UIView {
    
    private let data: ChallangeRing
    
    private var showRing: Bool
    private var lineWidth: CGFloat
    private var linePadding: CGFloat
    private var circleSize: CGFloat
    private var fontSize: CGFloat
    
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
    
    private lazy var text: UILabel = {
        let label = ViewFactory.label(data.progressPercentString())
            .font(.custom(.sfProMedium, size: fontSize))
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    init(data: ChallangeRing,
         lineWidth: CGFloat = 6,
         linePadding: CGFloat = 16,
         circleSize: CGFloat = 50,
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AnimateRingUIView {
    
    private func layout() {
        
        self.addSubview(backgroundView)
        backgroundView.addSubview(backgroundCircle)
        backgroundView.addSubview(progressCircle)
        backgroundView.addSubview(text)
        
        backgroundView.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
        
        backgroundCircle.snp.makeConstraints { make in
            make.center.equalTo(backgroundCircle)
        }
        
        progressCircle.snp.makeConstraints { make in
            make.center.equalTo(backgroundCircle)
        }
        
        text.snp.makeConstraints { make in
            make.center.equalTo(backgroundView)
            make.width.height.equalTo(self.circleSize / 2)
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
        
        let segmentLayer = createLayer(path: segmentPath, lineColor: lineColor, isAnimate: isAnimate)
        view.layer.addSublayer(segmentLayer)
        
        return view
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
        
        if isAnimate {
            addAnimation(to: segmentLayer, duration: 0.8)
        }
        
        return segmentLayer
    }
    
    private func createSegment(startAngle: CGFloat, 
                               endAngle: CGFloat,
                               radius: CGFloat,
                               superViewLayer: CALayer) -> UIBezierPath {
        let centerPoint = superViewLayer.anchorPoint
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

}

#if DEBUG
import SwiftUI

struct AnimateRingUIView_Previews: PreviewProvider {
    
    static let challange = ChallangeRing(type: .distance, count: 50, maxCount: 100)
    
    static var previews: some View {
        UIViewPreview {
            AnimateRingUIView(data: challange, circleSize: 50)
        }
        .frame(width: 100, height: 100)

    }
}
#endif
