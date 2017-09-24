//: Playground - noun: a place where people can play

import UIKit
import AsynthPlayground
import PlaygroundSupport



func mockSynthResult() -> [AsynthResult] {
    var results = [AsynthResult]()
    for number in 0...10 {
        var label = ""
        switch number {
        case 0, 3, 5, 7, 10:
            label = "not bowl"
        case 9:
            label = "not bowl"
        case 1,2,4,6,8:
            label = "disturbed"
        default:
            break
        }
        let probability = Double(number) * 0.1
        let result = AsynthResult(label: label, probability: probability)
        print(result.label)
        print(result.probability)
        results.append(result)
    }
    return results
}

let soundMap = ResonanceSoundMap(predictionsPerNote: 11, wave: triangle)
let results = mockSynthResult()
results.forEach { (result) in
    soundMap.addResult(result)
}



PlaygroundPage.current.needsIndefiniteExecution = true



