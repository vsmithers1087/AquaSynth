//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
containerView.backgroundColor = UIColor.black
let imageView = UIImageView(frame: containerView.frame)
imageView.image = UIImage(named: "background.png")
containerView.addSubview(imageView)
PlaygroundPage.current.liveView = containerView


func calculatePoints(frame: CGRect, level: Int) {
    let verticalOffset = frame.height / 20
    let stepHorizontal = frame.width / CGFloat(level)
    
}

class IconWaveAnimation {

    var imageView: UIImageView
    
    var offsetX: CGFloat {
        return imageView.frame.width * 0.10
    }

    init(imageView: UIImageView) {
        self.imageView = imageView
    }

    func animatePath(point1: CGPoint, point2: CGPoint, finished: @escaping () -> Void) {
        imageView.layer.sublayers?.removeAll()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0 + offsetX, y: imageView.frame.height / 2))
        path.addCurve(to: CGPoint(x: imageView.frame.height - offsetX, y: imageView.frame.height / 2), controlPoint1: point1, controlPoint2: point2)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = containerView.frame
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 8.0
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
            finished()
        }
    }
}

let iconAnimation = IconWaveAnimation(imageView: imageView)

func repeatAnimation(index: Int, x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat) {
    var idx = index
    iconAnimation.animatePath(point1: CGPoint(x: x1, y: y1), point2: CGPoint(x: x2, y: y2)) {
        if index < 6 {
            idx += 1
            repeatAnimation(index: idx, x1: x1 + 20 , y1: y1 - 100, x2: x2 - 20, y2: y2 + 100)
        }
    }
}

repeatAnimation(index: 0, x1: 200, y1: 300, x2: 400, y2: 300)

func mapPointsFor(view: UIView, level: Int) {
    let pointCount = 15
    let strideX = view.frame.width / CGFloat(pointCount)
    let verticalOffset = view.frame.height * CGFloat(CGFloat(level) * 0.01)
    var points = [CGPoint]()
    for point in 0...pointCount {
        let x = CGFloat(point) * strideX
        let y = point % 2 == 0 ? verticalOffset : -(verticalOffset)
        let endPoint = CGPoint(x: x, y: y)
        points.append(endPoint)
    }
    print(points)
}
mapPointsFor(view: containerView, level: 40)

