//: Playground - noun: a place where people can play

import UIKit
import AsynthPlayground
import PlaygroundSupport

func mockSynthResult() -> [AsynthResult] {
    var results = [AsynthResult]()
    for number in 0...10 {
        var label = AsynthResultLabel.none
        switch number {
        case 0, 3, 5, 7, 10:
            label = AsynthResultLabel.noBowl
        case 9:
            label = AsynthResultLabel.disturbed
        case 1,2,4,6,8:
            label = AsynthResultLabel.still
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
    let result = soundMap.addResult(result)
    print(result)
}

//PlaygroundPage.current.needsIndefiniteExecution = true



