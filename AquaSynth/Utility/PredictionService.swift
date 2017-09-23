//
//  PredictionService.swift
//  AquaSynth
//
//  Created by Vincent Smithers on 9/23/17.
//  Copyright © 2017 Vincent Smithers. All rights reserved.
//

import UIKit
import CoreML

public class PredictionService: NSObject {
    
    let model: MLModel
    let dimension: Int
    var currentLabel = "N/A"
    var currentScore = 0
    
    public init(model: MLModel, dimension: Int) {
        self.model = model
        self.dimension = dimension
    }
    
    open func predict(image: UIImage) -> AsynthResult? {

        guard let buffer  = UIImage.toPixelBuffer(image: image, dimension: dimension)  else { fatalError("Could not convert image to pixel buffer") }
        
        //if let prediction = try? model.prediction(from: buffer) {
            //print(prediction.prob)
            //print(prediction.)
//            prediction.prob.forEach({ (label, score) in
//                //guard label != "xA" else { return }
//                let realNum = score * Double(100)
//                if realNum > currentScore && realNum  > 0 {
//                    print("Real Num: \(realNum), Label: \(label)")
//                    currentScore = realNum
//                    currentLabel = label
//                }
//            })
            //return LabeLInfo(label: currentLabel, prob: prediction.prob)
        //}
        return nil
    }
}
