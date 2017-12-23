//: Playground - noun: a place where people can play

import UIKit

import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
containerView.backgroundColor = UIColor.yellow
PlaygroundPage.current.liveView = containerView

class ArrowButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       setBackgroundImage(UIImage(named: "background"), for: .normal)
        layer.borderWidth = 2.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func beginArrowAnimation() {
        let point1 = CGPoint(x: 8, y: 8)
        let point2 = CGPoint(x: 8, y: frame.height - 8)
        let point3 = CGPoint(x: frame.width - 8, y: frame.height / 2)
        let path = UIBezierPath()
        path.move(to: point1)
        path.addLine(to: point2)
        path.addLine(to: point3)
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = frame
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 2.0
        shapeLayer.lineCap = kCALineCapRound
        
        shapeLayer.strokeStart = 0
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.duration = 1
        strokeAnimation.fromValue = 0
        strokeAnimation.toValue = 1
        strokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        shapeLayer.add(strokeAnimation, forKey: "strokeAnim")
        imageView?.layer.addSublayer(shapeLayer)
    }
}

let arrowButton = ArrowButton(frame: CGRect(x: 200, y: 200, width: 100, height: 100))
containerView.addSubview(arrowButton)
