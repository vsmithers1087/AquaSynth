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
        iconWaveAnimation = IconWaveAnimation(imageView: imageView)
    }
}
