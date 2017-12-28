//
//  IconWaveAnimation.swift
//  AquaSynth
//
//  Created by Vincent Smithers on 12/27/17.
//  Copyright © 2017 Vincent Smithers. All rights reserved.
//

import UIKit

class IconWaveAnimation {
    
    var imageView: UIImageView
    
    var offsetX: CGFloat {
        return imageView.frame.width * 0.10
    }
    
    init(imageView: UIImageView) {
        self.imageView = imageView
    }
    
    func animatePath(points: [CGPoint], level: CGFloat) {
        guard points.count > 0 else { return }
        let median = points.count / 2
        imageView.layer.sublayers?.removeAll()
        let path = UIBezierPath()
        path.move(to: points.first!)
        for (index, point) in points.enumerated() {
            if index > 1 && index < points.count - 1 {
                let medianDifference = abs(median - abs(index - median))
                let offsetY = index % 2 == 0 ? CGFloat(medianDifference * Int(level)) : -CGFloat(medianDifference * Int(level))
                let newPoint = CGPoint(x: point.x, y: point.y + offsetY)
                path.addQuadCurve(to: newPoint, controlPoint: newPoint)
            }
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = imageView.frame
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 4.0
        shapeLayer.lineCap = kCALineCapRound
        
        shapeLayer.strokeStart = 0
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.duration = 1
        strokeAnimation.fromValue = 0
        strokeAnimation.toValue = 1
        strokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        shapeLayer.add(strokeAnimation, forKey: "strokeAnim")
        imageView.layer.addSublayer(shapeLayer)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + strokeAnimation.duration) {
        }
    }
    
    func mapPointsFor(level: CGFloat) {
        let pointCount = 13
        let strideX = (imageView.frame.width - offsetX) / CGFloat(pointCount)
        let verticalZero = imageView.frame.height / 2
        var points = [CGPoint(x: offsetX, y: verticalZero)]
        for point in 1...pointCount {
            let x = CGFloat(point) * strideX
            let y = point % 2 == 0 ? verticalZero + level : verticalZero - level
            let endPoint = CGPoint(x: x, y: y)
            points.append(endPoint)
        }
        print(points)
        animatePath(points: points, level: level)
    }
}

