//
//  ArrowButton.swift
//  AquaSynth
//
//  Created by Vincent Smithers on 12/23/17.
//  Copyright © 2017 Vincent Smithers. All rights reserved.
//

import UIKit

class ArrowButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBackgroundImage(UIImage(named: "iconBackground"), for: .normal)
        beginArrowAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func beginArrowAnimation() {
        let point1 = CGPoint(x: 40, y:35)
        let point2 = CGPoint(x: 40, y: (frame.height / 2 - 5))
        let point3 = CGPoint(x: 45, y: (frame.height / 2))
        let point4 = CGPoint(x: 40, y: (frame.height / 2 + 5))
        let point5 = CGPoint(x: 40, y: frame.height - 35)
        let point6 = CGPoint(x: frame.width - 35, y: frame.height / 2)
        let path = UIBezierPath()
        path.move(to: point1)
        path.addLine(to: point2)
        path.addLine(to: point3)
        path.addLine(to: point4)
        path.addLine(to: point5)
        path.addLine(to: point6)
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = bounds
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 3.0
        shapeLayer.lineCap = kCALineCapRound
        
        shapeLayer.strokeStart = 0
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.duration = 2.3
        strokeAnimation.fromValue = 0
        strokeAnimation.toValue = 1
        strokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        strokeAnimation.repeatCount = .infinity
        shapeLayer.add(strokeAnimation, forKey: "strokeAnim")
        layer.addSublayer(shapeLayer)
    }
}

