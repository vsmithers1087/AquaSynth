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
        synth = Synth(sounds: [Sound(wave: wave, volume: 1)])
    }
    
    public func playForResult(_ result: AsynthResult) -> String {
        var frequency = 0
        print(result.label)
        switch result.label {
        case AsynthResultLabel.still:
            frequency = Int(result.probability * Double(100))
            setSynthForStill(frequency: frequency)
            return "Frequency Still: \(frequency) Hertz"
        case AsynthResultLabel.disturbed:
            frequency = Int(result.probability * Double(800))
            setSynthForDisturbed(frequency: frequency)
            return "Frequency Disturbed: \(frequency) Hertz"
        case AsynthResultLabel.noBowl, .none:
            frequency = 23
            setSynthForNoBowl(frequency: frequency)
            return "No water in sight..."
        }
    }
    
    private func setSynthForStill(frequency: Int) {
        synth.freqMod = sin
        synth.envelope.attack = 0.5
        synth.envelope.release = 0.3
        synth.envelope.sustain = 0.7
        synth.effects = [Effect.delay(delayTime: 0.3, wetDryMix: 0.6, feedback: 0.9)]
        synth.play(frequency)
    }
    
    private func setSynthForDisturbed(frequency: Int) {
        synth.freqMod = saw
        synth.envelope.attack = 0.9
        synth.envelope.release = 0.5
        synth.envelope.sustain = 0.8
        synth.effects = [Effect.delay(delayTime: 0.3, wetDryMix: 0.9, feedback: 0.5)]
        synth.play(frequency)
    }
    
    private func setSynthForNoBowl(frequency: Int) {
        synth.freqMod = noise
        synth.envelope.attack = 0.5
        synth.envelope.release = 0.5
        synth.play(frequency)
    }
}
