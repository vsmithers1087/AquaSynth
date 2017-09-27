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
        case 6,8,9:
            label = AsynthResultLabel.disturbed
        case 1,2,4:
            label = AsynthResultLabel.still
        default:
            break
        }
        let probability = Double(number) * 0.1
        let result = AsynthResult(label: label, probability: probability)
        results.append(result)
    }
    return results
}

let soundMap = ResonanceSoundMap(predictionsPerNote: 11, wave: triangle)
let results = mockSynthResult()
results.forEach { (label) in
    //usleep(UInt32(10e6 * 0.1))
    sleep(2)
    print(label.label)
    soundMap.playForResult(label)
}

//PlaygroundPage.current.needsIndefiniteExecution = true



