//
//  FrequencyResultView.swift
//  AquaSynth
//
//  Created by Vincent Smithers on 9/21/17.
//  Copyright © 2017 Vincent Smithers. All rights reserved.
//

import UIKit

class FrequencyResultView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    var iconWaveAnimation: IconWaveAnimation!
    
    override func draw(_ rect: CGRect) {
        setBlurView()
    }
    
    func setupIconWaveAnimation() {
        iconWaveAnimation = IconWaveAnimation(imageView: imageView)
        iconWaveAnimation.imageView.backgroundColor = UIColor.clear
    }
    
    func redraw() {
        subviews.forEach { (subView) in
            subView.frame = bounds
        }
    }
    
    func setBlurView() {
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            let backgroundBlackImageView = UIImageView(frame: bounds)
            backgroundBlackImageView.image = UIImage(named: "backgroundBlack")
            addSubview(backgroundBlackImageView)
            backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: .prominent)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.layer.opacity = 0.3
            blurEffectView.frame = bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(blurEffectView)
            bringSubview(toFront: imageView)
            bringSubview(toFront: label)
            label.isHidden = true
        }
    }
}
