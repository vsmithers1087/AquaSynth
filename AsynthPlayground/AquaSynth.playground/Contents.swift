//: Playground - noun: a place where people can play

import UIKit
import AsynthPlayground
import PlaygroundSupport

//func mockSynthResult() -> [AsynthResult] {
//    var results = [AsynthResult]()
//    for number in 0...10 {
//        var label = ""
//        switch number {
//        case 0, 3, 5, 7, 10:
//            label = "not bowl"
//        case 9:
//            label = "still"
//        case 1,2,4,6,8:
//            label = "disturbed"
//        default:
//            break
//        }
//        let probability = Double(number) * 0.1
//        let result = AsynthResult(label: label, probability: probability)
//        print(result.label)
//        print(result.probability)
//        results.append(result)
//    }
//    return results
//}
//
//let soundMap = ResonanceSoundMap(predictionsPerNote: 11, wave: triangle)
//let results = mockSynthResult()
//results.forEach { (result) in
//    soundMap.addResult(result)
//}

let triangle: (Float) -> Float = { t in
    let a = t - floor(t + 0.5)
    let b = pow(-1.0, floor(t + 0.5))
    return 2 * a * b    //Inspect me in the sidebar
}
let triangleSynth = Synth(sounds: [Sound(wave: triangle, volume: 1)], sampleRate: 8000)
triangleSynth.play(Note.C(3))
usleep(UInt32(10e6 * 0.01))
triangleSynth.stop()

let saw: (Float) -> Float = { t in
    return t - floor(t / (2 * .pi))    //Inspect me in the sidebar
}
let sawSynth = Synth(sounds: [Sound(wave: saw, volume: 1)], sampleRate: 8000)
sawSynth.play(Note.C(3))
usleep(UInt32(10e6 * 0.01))
sawSynth.stop()

let noise: (Float) -> Float = { t in
    return Float(1.0 - Float(arc4random()) / Float(UINT32_MAX / 2))    //Inspect me in the sidebar
}
let noiseSynth = Synth(sounds: [Sound(wave: noise, volume: 1)], sampleRate: 8000)
noiseSynth.play(Note.C(3))
usleep(UInt32(10e6 * 0.01))
//noiseSynth.stop()




