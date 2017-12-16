//
//  PredictionService.swift
//  AquaSynth
//
//  Created by Vincent Smithers on 9/23/17.
//  Copyright © 2017 Vincent Smithers. All rights reserved.
//

import UIKit
import CoreML

public class AsynthPredictionService: NSObject {
    
    let model = Asynth()
    let dimension: Int
    var currentLabel = "N/A"
    var currentScore: Double = 0
    
    public init(dimension: Int) {
        self.dimension = dimension
    }
    
    open func predict(image: UIImage) -> AsynthResult? {
        var result: AsynthResult?
        guard let buffer  = image.toPixelBuffer(image: image, dimension: dimension) else { fatalError("Could not convert image to pixel buffer") }
        
        if let prediction = try? model.prediction(data: buffer) {
            var currentStill: Double = 0
            var currentDisturbed: Double = 0
            var currentXa: Double = 0
            
            prediction.prob.forEach({ (label, score) in
                var realNum = score * Double(100)
                switch label {
                case "still":
                    print("STILL \(realNum)")
                    currentStill = realNum
                    //realNum += 9
                case "disturbedA":
                    print("disturbed \(realNum)")
                    currentDisturbed = realNum
                case "xA":
                    print("xA \(realNum)")
                    currentXa = realNum
                default: break
                }
                
                if realNum > currentScore && (realNum  > 0  && realNum < 100){
                    let allGreaterThanZero = currentStill > 0 && currentDisturbed > 0 && currentXa > 0
                    let onlyXaGreaterThanZero = currentStill < 0 && currentDisturbed < 0 && currentXa > 0
                    
                    currentScore = realNum
                    currentLabel = label
                    result = AsynthResult(className: label, probability: currentScore)
                    if allGreaterThanZero {
                        let minVal = [currentStill, currentDisturbed, currentXa].min()
                        
                    }
                }
            })
            currentScore = 0
            return result
        }
        return nil
    }
}
