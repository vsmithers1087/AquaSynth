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
    var currentStill: [String: Double] = ["still": 0]
    var currentDisturbed:[String: Double] = ["disturbedA": 0]
    var currentXa: [String: Double] = ["xA": 0]
    var disturbedPeak: Double = 0
    var disturbedFluctuation: Double = 0
    
    public init(dimension: Int) {
        self.dimension = dimension
    }
    
    open func predict(image: UIImage) -> AsynthResult? {
        var result: AsynthResult?
        guard let buffer  = image.toPixelBuffer(image: image, dimension: dimension) else { fatalError("Could not convert image to pixel buffer") }
        
        if let prediction = try? model.prediction(data: buffer) {
            
            prediction.prob.forEach({ (label, score) in
                let realNum = score
                switch label {
                case "still":
                    currentStill["still"] =  realNum
                   // print("STILL \(currentStill["still"]!)")
                case "disturbedA":
                    currentDisturbed["disturbedA"] =  realNum
                   // print("disturbed \(currentDisturbed["disturbedA"]!)")
                    disturbedFluctuation = abs(disturbedPeak - realNum)
                case "xA":
                    currentXa["xA"] = realNum
                   // print("NONE:: \(currentXa["xA"]!)")
                default: break
                }
            })
            
            var currentLow: Double = 101
            let predictions = [currentStill, currentDisturbed, currentXa]
            predictions.forEach({ (val) in
                if val.values.first! < currentLow {
                    currentLow = val.values.first!
                    currentLabel = val.keys.first!
                    currentScore = currentLow
                }
            })
            
            if currentLow < 0.001 || currentStill["still"] ?? 0 > 0.99 {
                result = AsynthResult(className: "xA", probability: currentScore)
            } else if disturbedFluctuation > 0.1 {
                result = AsynthResult(className: "disturbedA", probability: currentScore)
            } else {
                result = AsynthResult(className: currentLabel, probability: currentScore)
            }

            disturbedPeak = currentDisturbed["disturbedA"] ?? 0
            currentStill = ["still": 0]
            currentDisturbed = ["disturbedA": 0]
            currentXa = ["xA": 0]
            currentScore = 0
            return result
        }
        return nil
    }
}
