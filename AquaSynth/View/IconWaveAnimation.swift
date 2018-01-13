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
    var currentPeak: CGFloat = 0
    
    var offsetX: CGFloat {
        return (imageView.frame.width * 0.13) + 13
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
                let offsetY = index % 2 == 0 ? CGFloat(medianDifference * Int(level * 1.2)) : -CGFloat(medianDifference * Int(level * 1))
                let newPoint = CGPoint(x: point.x, y: point.y + offsetY)
                let controlPoint = CGPoint(x: newPoint.x - 4, y: newPoint.y + offsetY)
                path.addQuadCurve(to: newPoint, controlPoint: controlPoint)
            }
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = imageView.bounds
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 4.0
        shapeLayer.lineCap = kCALineCapRound
        
        shapeLayer.lineWidth = 2.0
        
        let lineWidthAnimation = CABasicAnimation(keyPath: "lineWidth")
        lineWidthAnimation.toValue = 5.0
        lineWidthAnimation.duration = 0.75
        lineWidthAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        lineWidthAnimation.autoreverses = true
        lineWidthAnimation.repeatCount = 1
        
        shapeLayer.add(lineWidthAnimation, forKey: "lineWidthAnimation")
        
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
    
    func animateForFrequency(_ prediction: Double, level: AsynthResult) {
        switch level.label {
        case .noBowl, .none:
            break
        case .still:
            var stillPeak = 0.8 + CGFloat(prediction / 10000)
            if stillPeak < currentPeak {
                currentPeak -= 1.9
                stillPeak = currentPeak
            }
            mapPointsFor(level: stillPeak)
        case .disturbed:
            currentPeak = 5.0 + CGFloat(prediction / 100)
            mapPointsFor(level: currentPeak)
        }
    }
    
    //(_ prediction: Double, level: AsynthResultLabel)
    func mapPointsFor(level: CGFloat) {
        let pointCount = 21
        let endPointX = imageView.frame.width 
        let strideX = (imageView.frame.width - offsetX) / CGFloat(pointCount)
        let verticalZero = imageView.frame.height / 2
        var points = [CGPoint(x: offsetX, y: verticalZero)]
        for point in 4...pointCount  {
            let x = CGFloat(point) * strideX
            let y = point % 2 == 0 ? verticalZero + (level * 0.5) : verticalZero - (level * 0.5)
            let endPoint = CGPoint(x: x, y: y)
            points.append(endPoint)
        }
        points.append(CGPoint(x: endPointX, y: verticalZero))
        animatePath(points: points, level: level)
    }
}

