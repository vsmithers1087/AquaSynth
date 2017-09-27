//
//  ResonanceSoundMap.swift
//  AquaSynth
//
//  Created by Vincent Smithers on 9/23/17.
//  Copyright © 2017 Vincent Smithers. All rights reserved.
//

import UIKit

public class ResonanceSoundMap {
    
    public var predictionsPerNote: Int
    public var wave: (Float) -> Float
    private var synth: Synth
    private var asynthResults = [AsynthResult]()
    private var frequencies = [Int]()

    public init(predictionsPerNote: Int, wave: @escaping (Float) -> Float) {
        self.predictionsPerNote = predictionsPerNote
        self.wave = wave
        synth = Synth(sounds: [Sound(wave: wave, volume: 1)], sampleRate: 44100)
    }
    
    public func playForResult(_ result: AsynthResult) -> String {
        var frequency = 0
        switch result.label {
        case AsynthResultLabel.still:
            synth.freqMod = sin
            synth.envelope.attack = 0.5
            synth.envelope.release = 0.3
            synth.envelope.sustain = 0.7
            synth.effects = [Effect.delay(delayTime: 0.3, wetDryMix: 0.6, feedback: 0.9)]
            frequency = Int(result.probability * Double(100))
            synth.play(frequency)
        case AsynthResultLabel.disturbed:
            synth.freqMod = sin
            synth.envelope.attack = 0.9
            synth.envelope.release = 0.5
            synth.envelope.sustain = 0.8
            synth.effects = [Effect.delay(delayTime: 0.3, wetDryMix: 0.9, feedback: 0.5)]
            frequency = Int(result.probability * Double(400))
            synth.play(frequency)
        case AsynthResultLabel.noBowl:
            synth.freqMod = noise
            synth.envelope.attack = 0.5
            synth.envelope.release = 0.5
            frequency = 23
            synth.play(frequency)
        case AsynthResultLabel.none: break
        }
        return "Frequency: \(frequency) Hertz"
    }
    
//    public func playForResult(_ result: AsynthResult) -> String {
//        var frequency = 0
//        switch result.label {
//        case AsynthResultLabel.still:
//            stillSynth.freqMod = triangle
//            frequency = Int(result.probability * Double(10))
//            stillSynth.play(frequency)
//        case AsynthResultLabel.disturbed:
//            stillSynth.freqMod = saw
//            frequency = Int(result.probability * Double(500))
//            stillSynth.envelope.attack = 0.7
//            stillSynth.envelope.decay = 0.6
//            stillSynth.envelope.release = 0.5
//            stillSynth.envelope.sustain = 0.4
//            stillSynth.freqModAmount = 0.8
//            stillSynth.effects = [Effect.distortion(decimation: 90, decimationMix: 40, ringModMix: 60, finalMix: 20), Effect.delay(delayTime: 30, wetDryMix: 70, feedback: 70)]
//            stillSynth.play(frequency)
//        case AsynthResultLabel.noBowl:
//            stillSynth.envTime = 4
//            stillSynth.freqModAmount = 0.8
//            stillSynth.freqMod = noise
//            frequency = 45
//            stillSynth.play(frequency)
//        case AsynthResultLabel.none: break
//        }
//        return "Frequency: \(frequency) Hertz"
//    }
}

extension ResonanceSoundMap {
    
    public func addResult(_ result: AsynthResult) -> String {
        asynthResults.append(result)
        var returnVal: String?
        if asynthResults.count % predictionsPerNote == 0 {
            returnVal = mapResultsToSound()
            asynthResults.removeAll()
        }
        return returnVal ?? result.label.rawValue
    }
    
    public func mapResultsToSound() -> String {
        var frequency = 0
        for (label, score) in asynthResults {
            switch label {
            case AsynthResultLabel.still:
                let freqMod = 100 * score
                frequency += Int(freqMod)
            case AsynthResultLabel.disturbed:
                let freqMod = 200 * score
                frequency += Int(freqMod)
            case AsynthResultLabel.noBowl:
                let freqMod = 10 * score
                frequency += Int(freqMod)
            case .none:break
            }
        }
        
        synth.play(frequency)
        return "Frequency: \(frequency) Hertz"
    }
}
