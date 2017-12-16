//
//  ResonanceSoundMap.swift
//  AquaSynth
//
//  Created by Vincent Smithers on 9/23/17.
//  Copyright © 2017 Vincent Smithers. All rights reserved.
//

import UIKit
import AudioKit

class ResonanceSoundMap {
    
    //public var predictionsPerNote: Int
    private var asynthResults = [AsynthResult]()
    private var frequencies = [Int]()
    let bells = AKTubularBells()
    let string = AKPluckedString()
    var delay: AKDelay
    var reverb: AKReverb
    private var mixer: AKMixer
    private var hornWave = WavBase(filename: "horn.wav")
    private var cricket = WavBase(filename: "cricket.wav")
    
    init() {
        hornWave.player.volume = 0.4
        mixer = AKMixer(bells, string, cricket.player, hornWave.player)
        delay = AKDelay(mixer)
        reverb = AKReverb(delay)
        AudioKit.output = reverb
        AudioKit.start()
    }
    
    func playForFrequency(_ prediction: Double, level: AsynthResultLabel) {
        var triggerFreq: Double = 0
        switch level {
        case .noBowl:
            triggerFreq = 20
            delay.time = 0
            reverb.dryWetMix = 0
            cricket.player.play()
            bells.trigger(frequency: triggerFreq.midiNoteToFrequency())
        case .still:
            triggerFreq = 43 + prediction / 5
            delay.time = 2
            reverb.dryWetMix = 0.3
            bells.trigger(frequency: triggerFreq.midiNoteToFrequency())
            string.trigger(frequency: triggerFreq.midiNoteToFrequency())
        case .disturbed:
            triggerFreq = 70 + prediction / 5
            delay.time = 3
            reverb.dryWetMix = 0.6
            bells.trigger(frequency: triggerFreq.midiNoteToFrequency())
            string.trigger(frequency: (triggerFreq - 20).midiNoteToFrequency())
            hornWave.player.play()
        default:
            break
        }
    }
}
